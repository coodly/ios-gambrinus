#import "Beer.h"
#import "NSString+JCSValidations.h"
#import "NSString+Normalize.h"

NSString *const BeerDataKeyBindingKey = @"bindingKey";
NSString *const BeerDataKeyIdentifier = @"identifier";
NSString *const BeerDataKeyName = @"name";
NSString *const BeerDataKeyRbScore = @"rbscore";
NSString *const BeerDataKeyRbIdentifier = @"rbidentifier";
NSString *const BeerDataKeyBrewer = @"brewer";
NSString *const BeerDataKeyStyle = @"style";
NSString *const BeerDataKeyAlcohol = @"alcohol";
NSString *const BeerDataKeyAliased = @"aliased";

@interface Beer ()

@end

@implementation Beer

- (void)willSave {
    [super willSave];

    if (!self.name.hasValue) {
        return;
    }

    NSString *normalizedName = [self.name normalize];
    if ([normalizedName isEqualToString:self.normalizedName]) {
        return;
    }

    [self setNormalizedName:normalizedName];
}

@end
