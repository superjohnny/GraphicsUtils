//
//  BookingGuaranteeController.h
//  Venere
//
//  Created by David Taylor on 13/08/2013.
//
//

#import "VenereViewController.h"
#import "MASAvailResponse.h"
#import "BookingGuaranteeDetails.h"
#import "SlideUpSheet.h"
#import "ImageLabelView.h"
#import "BookingDetailsTextField.h"

@class BookingGuaranteeController;

@protocol BookingGuaranteeDelegate <NSObject>

- (void)updateBookingGuarantee:(BookingGuaranteeController *)bookingGuaranteeController dismissWithCancel:(BOOL) cancelled;

@end

@interface BookingGuaranteeController : VenereViewController <UIPickerViewDataSource, UIPickerViewDelegate, SlideUpSheetDelegate, ImageLabelViewDelegate, BookingDetailsTextFieldDelegate>

@property (weak, nonatomic) id <BookingGuaranteeDelegate> delegate;

@property (strong, nonatomic) MasDetailResult *detailResult;
@property (strong, nonatomic) NSArray *supportedCardTypes;
@property (strong, nonatomic) BookingGuaranteeDetails *bookingGuaranteeDetails;
@property (strong, nonatomic) MasStay *stay;
@property (nonatomic) BOOL firstView;
@end
