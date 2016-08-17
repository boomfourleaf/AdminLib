//
//  flPrinterEnum.h
//  Dining
//
//  Created by Nattapon Nimakul on 5/21/2558 BE.
//  Copyright (c) 2558 totizy@gmail.com. All rights reserved.
//

#ifndef Dining_flPrinterEnum_h
#define Dining_flPrinterEnum_h

typedef NS_ENUM(NSInteger, PRINTER_STATUS) {
    PRINTER_SUCCESS = 0,		/* Success */
    PRINTER_ERR_PARAM,			/* Invalid parameter */
    PRINTER_ERR_OPEN,			/* Open error */
    PRINTER_ERR_CONNECT,		/* Connection error */
    PRINTER_ERR_TIMEOUT,		/* Timeout */
    PRINTER_ERR_MEMORY,		/* Memory allocate error */
    PRINTER_ERR_ILLEGAL,		/* Illegal error */
    PRINTER_ERR_PROCESSING,	/* Processing error */
    PRINTER_ERR_UNSUPPORTED,	/* Unsupported model */
    PRINTER_ERR_OFF_LINE,       /* Printer Off-line */
    PRINTER_ERR_FAILURE = 255	/* Undefined or Unknown error */
};

#endif
