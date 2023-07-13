#import "SJPlayRetain.h"
#import <objc/runtime.h>
#import "AppDefineHeader.h"
@implementation UIControl (SJPlayRetain)
+ (void)load
{
  SEL system_sel = @selector(sendAction:to:forEvent:);
  Method system_method = class_getInstanceMethod(self, system_sel);
  SEL custom_sel = @selector(custom_sendAction:to:forEvent:);
  Method custom_method = class_getInstanceMethod(self, custom_sel);
  BOOL didAddMethod = class_addMethod(self, system_sel, method_getImplementation(custom_method), method_getTypeEncoding(custom_method));
  if (didAddMethod) {
    class_replaceMethod(self, custom_sel, method_getImplementation(system_method), method_getTypeEncoding(system_method));
  }else{
    method_exchangeImplementations(system_method, custom_method);
  }
}
- (NSTimeInterval )custom_acceptEventInterval{
  return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}
- (void)setCustom_acceptEventInterval:(NSTimeInterval)custom_acceptEventInterval{
  objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(custom_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval )custom_accept_up_EventTime{
  return [objc_getAssociatedObject(self, "UIControl_accept_up_EventTime") doubleValue];
}
- (void)setCustom_accept_up_EventTime:(NSTimeInterval)custom_accept_up_EventTime{
  objc_setAssociatedObject(self, "UIControl_accept_up_EventTime", @(custom_accept_up_EventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)custom_accept_down_EventTime{
  return [objc_getAssociatedObject(self, @"UIControl_accept_down_EventTime") doubleValue];
}
- (void)setCustom_accept_down_EventTime:(NSTimeInterval)custom_accept_down_EventTime
{
  objc_setAssociatedObject(self, @"UIControl_accept_down_EventTime", @(custom_accept_down_EventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (PPThread * )action_thread
{
  return objc_getAssociatedObject(self, @"SDThread_action");
}
- (void)setAction_thread:(PPThread *)action_thread
{
  objc_setAssociatedObject(self, @"SDThread_action", action_thread, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)postponed_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
  if (!self.action_thread) {
    self.action_thread = [PPThread currentSDThread:self.tag];
  }
  @weakify_self;
  [self.action_thread delay:self.custom_acceptEventInterval runBlock:^{
    DLog(@"delay ----------");
    dispatch_async(dispatch_get_main_queue(), ^{
      @strongify_self;
      [self custom_sendAction:action to:target forEvent:event];
    });
  }];
}
- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
  NSString * action_string = NSStringFromSelector(action);
  NSLog(@"touc event = %@",action_string);
  if (self.custom_acceptEventInterval > 0) {
    NSArray * action_up_list = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    if ([action_up_list containsObject:action_string]) {
      DLog(@"touch up %f > %f",NSDate.date.timeIntervalSince1970 - self.custom_accept_down_EventTime,self.custom_acceptEventInterval);
      BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.custom_accept_down_EventTime >= self.custom_acceptEventInterval);
      self.custom_accept_up_EventTime = NSDate.date.timeIntervalSince1970;
      if (needSendAction) {
        [self custom_sendAction:action to:target forEvent:event];
      }else{
        [self postponed_sendAction:action to:target forEvent:event];
      }
    }
    NSArray * action_down_list = [self actionsForTarget:target forControlEvent:UIControlEventTouchDown];
    if ([action_down_list containsObject:action_string]) {
      DLog(@"touch down %f > %f",NSDate.date.timeIntervalSince1970 - self.custom_accept_up_EventTime,self.custom_acceptEventInterval);
      BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.custom_accept_up_EventTime >= self.custom_acceptEventInterval);
      self.custom_accept_down_EventTime = NSDate.date.timeIntervalSince1970;
      if (needSendAction) {
        if (!self.action_thread) {
          self.action_thread = [PPThread currentSDThread:self.tag];
        }
        [self.action_thread interrupt];
        [self custom_sendAction:action to:target forEvent:event];
      }else{
        DLog(@"这一次，我不抓取了");
        if (self.action_thread) {
          [self custom_sendAction:action to:target forEvent:event];
          [self.action_thread interrupt];
          DLog(@"cancel delay   -------------- ");
        }
      }
    }
  }else{
    [self custom_sendAction:action to:target forEvent:event];
  }
}
@end
