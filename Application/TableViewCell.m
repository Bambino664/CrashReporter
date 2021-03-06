/**
 * Name: CrashReporter
 * Type: iOS application
 * Desc: iOS app for viewing the details of a crash, determining the possible
 *       cause of said crash, and reporting this information to the developer(s)
 *       responsible.
 *
 * Author: Lance Fetters (aka. ashikase)
 * License: GPL v3 (See LICENSE file for details)
 */

#import "TableViewCell.h"

#import "TableViewCellLine.h"

#define kColorName   [UIColor blackColor]
#define kColorViewed [UIColor grayColor]

static const UIEdgeInsets kContentInset = (UIEdgeInsets){10.0, 15.0, 10.0, 15.0};
static const CGFloat kFontSizeName = 18.0;

@implementation TableViewCell {
    UILabel *nameLabel_;
    NSMutableArray *lines_;
    UIView *topSeparatorView_;
    UIView *bottomSeparatorView_;
}

@synthesize nameLabel = nameLabel_;
@synthesize referenceDate = referenceDate_;
@synthesize viewed = viewed_;

@dynamic showsTopSeparator;

+ (CGFloat)cellHeight {
    return kContentInset.top + kContentInset.bottom + (kFontSizeName + 4.0);
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil ) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    return dateFormatter;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        // NOTE: A background view is necessary for older versions of iOS.
        // NOTE: Confirmed necessary for iOS 4.1.2, not necessary for iOS 8.4.
        //       Other versions unconfirmed.
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
        [backgroundView release];

        UIFont *font = [UIFont systemFontOfSize:kFontSizeName];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textColor = kColorName;
        [self.contentView addSubview:label];
        nameLabel_ = label;

        lines_ = [[NSMutableArray alloc] init];

        // Provide our own separator views for more control.
        UIView *separatorView;

        separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        separatorView.backgroundColor = [UIColor colorWithRed:(200.0 / 255.0) green:(199.0 / 255.0) blue:(204.0 / 255.0) alpha:1.0];
        separatorView.hidden = YES;
        [self addSubview:separatorView];
        topSeparatorView_ = separatorView;

        separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        separatorView.backgroundColor = [UIColor colorWithRed:(200.0 / 255.0) green:(199.0 / 255.0) blue:(204.0 / 255.0) alpha:1.0];
        [self addSubview:separatorView];
        bottomSeparatorView_ = separatorView;
    }
    return self;
}

- (void)dealloc {
    [referenceDate_ release];
    [nameLabel_ release];
    [lines_ release];
    [topSeparatorView_ release];
    [bottomSeparatorView_ release];
    [super dealloc];
}

- (TableViewCellLine *)addLine {
    TableViewCellLine *line = [[TableViewCellLine alloc] init];
    [self addSubview:line];
    [lines_ addObject:line];
    return [line autorelease];
}

#pragma mark - View (Layout)

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGSize contentSize = self.contentView.bounds.size;
    const CGFloat maxWidth = contentSize.width - kContentInset.left - kContentInset.right;
    CGSize maxSize = CGSizeMake(maxWidth, 10000.0);

    // Name.
    CGRect nameLabelFrame = CGRectZero;
    if ([[nameLabel_ text] length] > 0) {
        nameLabelFrame = [nameLabel_ frame];
        nameLabelFrame.origin.x = kContentInset.left;
        nameLabelFrame.origin.y = kContentInset.top;
        nameLabelFrame.size = [nameLabel_ sizeThatFits:maxSize];
    }
    [nameLabel_ setFrame:nameLabelFrame];

    // Lines.
    const CGFloat lineHeight = [TableViewCellLine defaultHeight];

    CGRect lineFrame = CGRectMake(
            kContentInset.left + 2.0,
            nameLabelFrame.origin.y + nameLabelFrame.size.height,
            maxWidth - 2.0,
            lineHeight
            );

    for (TableViewCellLine *line in lines_) {
        if ([[line.label text] length] > 0) {
            line.frame = lineFrame;
            lineFrame.origin.y += lineHeight;
        } else {
            line.frame = CGRectZero;
        }
    }

    // Separators.
    const CGFloat scale = [[UIScreen mainScreen] scale];
    const CGFloat separatorHeight = 1.0 / scale;
    const CGSize size = self.bounds.size;
    [topSeparatorView_ setFrame:CGRectMake(0.0, 0.0, size.width, separatorHeight)];
    [bottomSeparatorView_ setFrame:CGRectMake(0.0, size.height - separatorHeight, size.width, separatorHeight)];
}

#pragma mark - Configuration

- (void)configureWithObject:(id)object {
}

- (void)setText:(NSString *)text forLabel:(UILabel *)label {
    const NSUInteger oldLength = [[label text] length];
    const NSUInteger newLength = [text length];

    [label setText:text];

    if (((oldLength == 0) && (newLength != 0)) || ((oldLength != 0) && (newLength == 0))) {
        [self setNeedsLayout];
    }
}

- (void)setName:(NSString *)name {
    [self setText:name forLabel:nameLabel_];
}

#pragma mark - Properties

- (BOOL)showsTopSeparator {
    return topSeparatorView_.hidden;
}

- (void)setShowsTopSeparator:(BOOL)shows {
    topSeparatorView_.hidden = !shows;
}

- (void)setViewed:(BOOL)viewed {
    if (viewed_ != viewed) {
        viewed_ = viewed;
        nameLabel_.textColor = viewed ? kColorViewed : kColorName;
    }
}

@end

/* vim: set ft=objc ff=unix sw=4 ts=4 tw=80 expandtab: */
