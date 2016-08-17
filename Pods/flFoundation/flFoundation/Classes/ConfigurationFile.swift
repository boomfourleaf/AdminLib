//
//  ConfigurationFile.swift
//  Dining
//
//  Created by Nattapon Nimakul on 6/8/2559 BE.
//  Copyright © 2559 totizy@gmail.com. All rights reserved.
//

import Foundation

//MARK: Dining
public var DINING_MANAGEMENT_NAME: String { return "name" }
public var DINING_MANAGEMENT_ROOM: String { return "room" }
public var DINING_MANAGEMENT_TABLE_ZONE: String { return "table_zone" }
public var DINING_MANAGEMENT_TABLE_NAME: String { return "table_name" }
public var DINING_MANAGEMENT_TABLE_SPLIT: String { return "table_split" }
public var DINING_MANAGEMENT_SPLIT_COUNT: String { return "split_count" }
public var DINING_MANAGEMENT_CAPTAIN_COUNT: String { return "captain_count" }

//MARK: Printer
public var EPSON_TM_T81: String { return "TM-T81" }
public var EPSON_TM_T88V: String { return "TM-T88V" }
public var EPSON_TM_U220: String { return "TM-U220" }
public var STAR_TSP650II: String { return "STAR-TSP650II" }
public var STAR_TSP100III: String { return "STAR-TSP100III" }
public var STAR_SMS230I: String { return "STAR-SMS230I" }
public var STAR_SML200: String { return "STAR-SML200" }
public var STAR_MPOP: String { return "STAR-MPOP" }

// FOURLEAF Framework
public var FOURLEAF_VERSION_KEY: String { return "FOURLEAF_VERSION" }
public var FOURLEAF_VERSION_HAVE_CHANGE_KEY: String { return "FOURLEAF_VERSION_HAVE_CHANGE" }

// VAT
public var FOURLEAF_VAT_MODE_INCLUDED: String { return "INC" }
public var FOURLEAF_VAT_MODE_EXCLUDED: String { return "EXC" }

public var SERVCIE_CHARGE_MODE_INCLUDED: String { return "INC" }
public var SERVCIE_CHARGE_MODE_EXCLUDED: String { return "EXC" }

// Application Mode
public var ENABLE_ON_IPAD_PRINT_WITHOUT_INTERNET: Bool { return false }

public var LOG_NETWORK_DOWNLOAD_UPLOAD: Bool { return true }

// TIME OUT
public var NETWORK_SEND_REQUEST_TIMEOUT: Int { return 10 }
public var NETWORK_SEND_REQUEST_WITH_IMAGE_TIMEOUT: Int { return 30 }

// iOS UI
public var UI_STATUS_BAR_HEIGHT: Int { return 20 }

// Main Path
public var MAiN_NAV_BG: String { return "Navigation Bar_BG only" }

// API
public var API_ROOT_DATAS: String { return "datas" }
public var API_ROOT_STATUS: String { return "status" }
public var API_ROOT_STATUS_MSG: String { return "status_msg" }
public var API_ROOT_ADDITIONAL: String { return "additional" }
public var API_ROOT_GROUP_OPTION_LIST: String { return "group_option_list" }
public var API_DINING_SPECIALS: String { return "specials" }
public var API_DINING_GROUP_ORDERS: String { return "group_order" }
public var API_DINING_RESTAURANT_MODE: String { return "restaurant_mode" }
public var API_ROOT_FEEDBACK: String { return "feedback" }
public var API_ROOT_UPDATE_DATETIME: String { return "update_datetime" }
public var API_ROOT_UPDATE_HASH: String { return "update_hash" }
public var API_ROOT_SCROLL_CONTENT_INSET_TOP: String { return "scroll_content_inset_top" }
public var API_ROOT_SCROLL_CONTENT_INSET_BOTTOM: String { return "scroll_content_inset_bottom" }
public var API_ORDER_CONFIG: String { return "order_config" }
public var API_INVOICE_CONFIG: String { return "invoice_config" }
public var API_INVOICE_LOGO: String { return "hotel_logo" }
public var API_ROOT_STAFF_LIST: String { return "staff_list" }
public var API_STAFF_NAME: String { return "name" }
public var API_STAFF_PASSWORD: String { return "password" }
public var API_STAFF_PERM_MAKE_ORDER: String { return "perm_make_order" }
public var API_STAFF_PERM_VOID: String { return "perm_void" }
public var API_STAFF_PERM_PRINT_CHECK: String { return "perm_print_check" }
public var API_STAFF_PERM_MANAGE_TABLE: String { return "perm_manage_table" }
public var API_STAFF_PERM_CASHIER: String { return "perm_cashier" }
public var API_STAFF_PERM_CLOSE_SHIFT: String { return "perm_close_shift" }
public var API_STAFF_ID: String { return "staff_id" }
public var API_PRINTER_CONFIG: String { return "printers" }
public var API_DISCOUNT_FILTER: String { return "discount_filters" }
public var API_PRICE_PER_WEIGHT_KEY: String { return "price_per_weight" }
public var API_PRICE_PER_WEIGHT_ENABLE: String { return "ON" }
public var API_PRICE_PER_WEIGHT_DISABLE: String { return "OFF" }
public var API_ACTIVATE_RESULT: String { return "activate_result" }
public var API_ACTIVATE_RESULT_SUCCESS: String { return "success" }

// DINING
public var DINING_RESTAURANT_MODE_TABLE: String { return "table" }
public var DINING_RESTAURANT_MODE_PASSWORD: String { return "password" }
public var DINING_RESTAURANT_MODE_MAX_SPLIT_BILL: String { return "max_split_bill" }
public var DINING_RESTAURANT_MODE_TABLE_INPUT_MODE: String { return "table_input_mode" }
public var DINING_RESTAURANT_MODE_TABLE_INPUT_MODE_TABLE_SCROLL: String { return "PRESET" }
public var DINING_RESTAURANT_MODE_TABLE_INPUT_MODE_TABLE_GRID: String { return "TBGRID" }
public var DINING_RESTAURANT_MODE_TABLE_INPUT_MODE_TEXTINPUT: String { return "TEXTIN" }
public var DINING_RESTAURANT_MODE_PRINTER_SERVICES: String { return "printer_services" }
public var DINING_RESTAURANT_MODE_DISCOUNT_PERCENT_LABEL_STYLE: String { return "discount_percent_label_style" }

public var DINING_RESTAURANT_MODE_RESPONSE_ORDER_ID: String { return "billing_id" }
public var DINING_RESTAURANT_MODE_RESPONSE_TOTAL_PRICE: String { return "total_price" }
public var DINING_RESTAURANT_MODE_RESPONSE_TOTAL_PRICE_OPTION: String { return "total_price_option" }
public var DINING_RESTAURANT_MODE_RESPONSE_SERVICE_CHARGE: String { return "service_charge" }
public var DINING_RESTAURANT_MODE_RESPONSE_SERVICE_CHARGE_OPTION: String { return "service_charge_option" }
public var DINING_MODE_KEY: String { return "DINING_MODE" }
public var DINING_MODE_NORMAL: String { return "NORMAL" }
public var DINING_MODE_RESTAURANT: String { return "RESTAURANT" }



// LOG
public var USAGE_LOG_TXT: String { return "usage_log.txt" }
public var LOG_FILE_FOR_DEBUG: String { return "debug_log.txt" }

// Notification
public var FL_MODE_DID_CHANGE: String { return "FOURLEAF Mode Did Change" }

// HYBRIDE MODE
public var FOURLEAF_HYBRIDE_ENABLE: Bool { return false }

public var FOURLEAF_STORYBOARD_FOR_IOS8: Bool { return false }
public var FOURLEAF_SCROLLING_BOUNCES: Bool { return true }

public var FOURLEAF_SITE_INTERNET_CONDITION_VERYSLOW: Int { return 10 }
public var FOURLEAF_SITE_INTERNET_CONDITION_SLOW: Int { return 20 }
public var FOURLEAF_SITE_INTERNET_CONDITION_VERYFAST: Int { return 100 }
public var FOURLEAF_SITE_INTERNET_CONDITION: Int { return FOURLEAF_SITE_INTERNET_CONDITION_VERYFAST }

public var PRINTER_SERVICE_FETCH_INTERVAL_IDLE_STATE: Int { return 1 }
public var PRINTER_SERVICE_FETCH_INTERVAL: Int { return PRINTER_SERVICE_FETCH_INTERVAL_IDLE_STATE }
public var PRINTER_SERVICE_FETCH_INTERVAL_EXTEND_MAX: Int { return 5 }
public var PRINTER_SERVICE_WATCHDOG_TIMEOUT: Int { return 60 }

public var PRINTER_SERVICE_FETCH_MODE_CLOUD: Int { return 1 }
public var PRINTER_SERVICE_FETCH_MODE_PERSISTENCE: Int { return 2 }
public var PRINTER_SERVICE_FETCH_MODE: Int { return PRINTER_SERVICE_FETCH_MODE_CLOUD }

public var FOURLEAF_LOG_SYNC_SERVICE_INTERVAL: Int { return 5 }
public var FOURLEAF_LOG_ORDER_SERVICE_INTERVAL: Int { return 5 }
public var GLOBAL_ROOM_KEY: String { return "room" }

public var WATCHDOG_OK: Int { return 0 }
public var WATCHDOG_DIRTY: Int { return 1 }


public var CASHIER_MIRROR_SCREEN_OFF: String { return "OFF" }
public var CASHIER_MIRROR_SCREEN_ON: String { return "ON" }
public var CASHIER_MIRROR_SCREEN: String { return CASHIER_MIRROR_SCREEN_OFF }

public var CASHIER_MIRROR_SCREEN_MODE_MASTER: String { return "MASTER" }
public var CASHIER_MIRROR_SCREEN_MODE_MIRROR: String { return "MIRROR" }
public var CASHIER_MIRROR_SCREEN_MODE: String { return CASHIER_MIRROR_SCREEN_MODE_MASTER }
public var CASHIER_MIRROR_SCREEN_MODE_MASTER_IP: String { return "192.168.1.200" }

public var FOURLEAF_OFFLINE: String { return "FOURLEAF_OFFLINE" }
