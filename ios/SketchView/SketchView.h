//
//  SketchView.h
//  Sketch
//
//  Created by Keshav on 06/04/17.
//  Copyright © 2017 Particle41. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import "Paint.h"
#import "SketchTool.h"

@protocol SketchViewOnDrawDelegate <NSObject>
@optional
- (void)sketchViewOnDraw:(BOOL)isDrawing;
@end

@interface SketchView : UIView

@property (weak, nonatomic) id <SketchViewOnDrawDelegate> delegate;
-(void)clear;
-(void)setToolType:(SketchToolType) toolType;
-(void)setViewImage:(UIImage *)image;
-(void)setToolThickness:(CGFloat)thickness;

@end
