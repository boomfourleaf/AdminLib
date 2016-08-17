//
//  PrinterFunctions.h
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>

#import "CommonEnum.h"
#import "RasterDocument.h"
#import "flPrinterEnum.h"

@class SMBluetoothManager;

typedef enum {
    USE_LIMITS = 0,
    USE_FIXED = 1
} Limit;

typedef enum {
    NarrowWide_2_6 = 0,
    NarrowWide_3_9 = 1,
    NarrowWide_4_12 = 2,
    NarrowWide_2_5 = 3,
    NarrowWide_3_8 = 4,
    NarrowWide_4_10 = 5,
    NarrowWide_2_4 = 6,
    NarrowWide_3_6 = 7,
    NarrowWide_4_8 = 8
} NarrowWide;

typedef enum 
{
    NarrowWideV2_2_5 = 0,
    NarrowWideV2_4_10 = 1,
    NarrowWideV2_6_15 = 2,
    NarrowWideV2_2_4 = 3,
    NarrowWideV2_4_8 = 4,
    NarrowWideV2_6_12 = 5,
    NarrowWideV2_2_6 = 6,
    NarrowWideV2_3_9 = 7,
    NarrowWideV2_4_12 = 8
} NarrowWideV2;

typedef enum {
    No_Added_Characters_With_Line_Feed = 0,
    Adds_Characters_With_Line_Feed = 1,
    No_Added_Characters_Without_Line_Feed = 2,
    Adds_Characters_Without_Line_Feed = 3
} BarCodeOptions;

typedef enum
{
    _2_dots = 0,
    _3_dots = 1,
    _4_dots = 2
} Min_Mod_Size;

typedef enum _SMPrinterType {
    SMPrinterTypeUnknown = 0,
    SMPrinterTypeDesktopPrinterStarLine,
    SMPrinterTypePortablePrinterStarLine,
    SMPrinterTypePortablePrinterESCPOS,
    SMPrinterTypePortablePrintermPOP
} SMPrinterType;

@interface PrinterFunctions : NSObject

#pragma mark Show Firmware Information

+ (void)showFirmwareVersion:(NSString *)portName portSettings:(NSString *)portSettings;

#pragma mark Check whether supporting bluetooth setting

+ (NSInteger)hasBTSettingSupportWithPortName:(NSString *)portName
                                portSettings:(NSString *)portSettings;

#pragma mark Open Cash Drawer

+ (PRINTER_STATUS)OpenCashDrawerWithPortname:(NSString *)portName
                      portSettings:(NSString *)portSettings
                      drawerNumber:(NSUInteger)drawerNumber;

#pragma mark Check Status

+ (void)CheckStatusWithPortname:(NSString *)portName
                   portSettings:(NSString *)portSettings
                  sensorSetting:(SensorActive)sensorActiveSetting;

#pragma mark 1D Barcode

+ (void)PrintCode39WithPortname:(NSString *)portName
                   portSettings:(NSString *)portSettings
                    barcodeData:(unsigned char*)barcodeData
                barcodeDataSize:(unsigned int)barcodeDataSize
                 barcodeOptions:(BarCodeOptions)option
                         height:(unsigned char)height
                     narrowWide:(NarrowWide)width;
+ (void)PrintCode93WithPortname:(NSString *)portName
                   portSettings:(NSString *)portSettings
                    barcodeData:(unsigned char*)barcodeData
                barcodeDataSize:(unsigned int)barcodeDataSize
                 barcodeOptions:(BarCodeOptions)option
                         height:(unsigned char)height
                min_module_dots:(Min_Mod_Size) width;
+ (void)PrintCodeITFWithPortname:(NSString*)portName
                    portSettings:(NSString*)portSettings
                     barcodeData:(unsigned char*)barcodeData
                 barcodeDataSize:(unsigned int)barcodeDataSize
                  barcodeOptions:(BarCodeOptions)option
                          height:(unsigned char)height
                      narrowWide:(NarrowWideV2) width;
+ (void)PrintCode128WithPortname:(NSString*)portName
                    portSettings:(NSString*)portSettings
                     barcodeData:(unsigned char*)barcodeData
                 barcodeDataSize:(unsigned int)barcodeDataSize
                  barcodeOptions:(BarCodeOptions)option
                          height:(unsigned char)height
                 min_module_dots:(Min_Mod_Size)width;

#pragma mark 2D Barcode

+ (void)PrintQrcodeWithPortname:(NSString*)portName
                   portSettings:(NSString*)portSettings
                correctionLevel:(CorrectionLevelOption) correctionLevel
                          model:(Model)model
                       cellSize:(unsigned char)cellSize
                    barcodeData:(unsigned char*)barCodeData
                barcodeDataSize:(unsigned int)barCodeDataSize;
+ (void)PrintPDF417CodeWithPortname:(NSString *)portName
                       portSettings:(NSString *)portSettings
                              limit:(Limit)limit
                                 p1:(unsigned char)p1
                                 p2:(unsigned char)p2
                      securityLevel:(unsigned char)securityLevel
                         xDirection:(unsigned char)xDirection
                        aspectRatio:(unsigned char)aspectRatio
                        barcodeData:(unsigned char[])barcodeDat
                    barcodeDataSize:(unsigned int)barcodeDataSize;

#pragma mark Cut

+ (void)PerformCutWithPortname:(NSString *)portName
                  portSettings:(NSString*)portSettings
                       cutType:(CutType)cuttype;

#pragma mark TextFormatting

+ (void)PrintTextWithPortname:(NSString *)portName
                 portSettings:(NSString*)portSettings
                  slashedZero:(bool)slashedZero
                    underline:(bool)underline
                  invertColor:(bool)invertColor
                   emphasized:(bool)emphasized
                    upperline:(bool)upperline
                   upsideDown:(bool)upsideDown
              heightExpansion:(int)heightExpansion
               widthExpansion:(int)widthExpansion
                   leftMargin:(unsigned char)leftMargin
                    alignment:(Alignment) alignment
                     textData:(unsigned char *)textData
                 textDataSize:(unsigned int)textDataSize;

#pragma mark common

//+ (void)PrintImageWithPortname:(NSString *)portName
//                  portSettings:(NSString *)portSettings
//                  imageToPrint:(UIImage *)imageToPrint
//                      maxWidth:(int)maxWidth
//             compressionEnable:(BOOL)compressionEnable
//                withDrawerKick:(BOOL)drawerKick
//                   pageEndMode:(RasPageEndMode)pageEndMode;

+ (PRINTER_STATUS)PrintImageWithPortname:(NSString *)portName
                  portSettings:(NSString*)portSettings
                 imagesToPrint:(NSArray*)imagesToPrint
                      maxWidth:(int)maxWidth
             compressionEnable:(BOOL)compressionEnable
                withDrawerKick:(BOOL)drawerKick
                   pageEndMode:(RasPageEndMode)pageEndMode;

#pragma mark Bluetooth Setting

+ (SMBluetoothManager *)loadBluetoothSetting:(NSString *)portName
                                portSettings:(NSString *)portSettings;

#pragma mark Disconnect (Bluetooth)
+ (void)disconnectPort:(NSString *)portName
          portSettings:(NSString *)portSettings
               timeout:(u_int32_t)timeout;


#pragma mark Optimized for Speed
- (PRINTER_STATUS)openPrinterWithPortName:(NSString *)portName portSettings:(NSString *)portSettings timeoutMillis:(u_int32_t)timeoutMillis;
- (PRINTER_STATUS)closePrinter;
- (PRINTER_STATUS)openCashDrawerNumber:(NSUInteger)drawerNumber;
- (PRINTER_STATUS)sendCommand:(NSData *)commandsToPrint;
- (PRINTER_STATUS)PrintImages:(NSArray*)imagesToPrint portSettings:(NSString*)portSettings maxWidth:(int)maxWidth compressionEnable:(BOOL)compressionEnable withDrawerKick:(BOOL)drawerKick pageEndMode:(RasPageEndMode)pageEndMode;

@end
