
#import "RNSketchViewManager.h"


@implementation RNSketchViewManager

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_CUSTOM_VIEW_PROPERTY(selectedTool, NSInteger, SketchViewContainer)
{
    SketchViewContainer *currentView = !view ? defaultView : view;
    [currentView.sketchView setToolType:[RCTConvert NSInteger:json]];
}

RCT_CUSTOM_VIEW_PROPERTY(localSourceImagePath, NSString, SketchViewContainer)
{
    SketchViewContainer *currentView = !view ? defaultView : view;
    NSString *localFilePath = [RCTConvert NSString:json];
    dispatch_async(dispatch_get_main_queue(), ^{
        [currentView openSketchFile:localFilePath];
    });
}

RCT_CUSTOM_VIEW_PROPERTY(toolThickness, CGFloat, SketchViewContainer)
{
    SketchViewContainer *currentView = !view ? defaultView : view;
    [currentView.sketchView setToolThickness:[RCTConvert CGFloat:json]];
}

RCT_EXPORT_VIEW_PROPERTY(onDraw, RCTBubblingEventBlock)

RCT_EXPORT_MODULE(RNSketchView)

-(UIView *)view
{
    self.sketchViewContainer = [[[NSBundle mainBundle] loadNibNamed:@"SketchViewContainer" owner:self options:nil] firstObject];
    return self.sketchViewContainer;
}

RCT_EXPORT_METHOD(saveSketch:(nonnull NSNumber *)reactTag) {
    dispatch_async(dispatch_get_main_queue(), ^{
        SketchFile *sketchFile = [self.sketchViewContainer saveToLocalCache];
        [self onSaveSketch:sketchFile];
    });
}

RCT_EXPORT_METHOD(clearSketch:(nonnull NSNumber *)reactTag) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sketchViewContainer.sketchView clear];
    });
}

RCT_EXPORT_METHOD(exportSketch:(nonnull NSNumber *)reactTag) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *base64 = [self.sketchViewContainer getBase64];
        [self onExportSketch:base64];
    });
}

RCT_EXPORT_METHOD(changeTool:(nonnull NSNumber *)reactTag toolId:(NSInteger) toolId) {
    [self.sketchViewContainer.sketchView setToolType:toolId];
}

-(void)onSaveSketch:(SketchFile *) sketchFile
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"onSaveSketch" body:
  @{
    @"localFilePath": sketchFile.localFilePath,
    @"imageWidth": [NSNumber numberWithFloat:sketchFile.size.width],
    @"imageHeight": [NSNumber numberWithFloat:sketchFile.size.height]
    }];
}

-(void)onExportSketch:(NSString *) encoding
 {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"onExportSketch" body:@{ @"base64Encoded": encoding }];
 }

@end
