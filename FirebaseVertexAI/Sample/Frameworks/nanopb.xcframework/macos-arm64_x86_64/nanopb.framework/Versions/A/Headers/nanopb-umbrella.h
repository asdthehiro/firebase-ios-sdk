#ifdef __OBJC__
#import <Cocoa/Cocoa.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "pb.h"
#import "pb_common.h"
#import "pb_decode.h"
#import "pb_encode.h"

FOUNDATION_EXPORT double nanopbVersionNumber;
FOUNDATION_EXPORT const unsigned char nanopbVersionString[];
