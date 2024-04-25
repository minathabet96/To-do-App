//
//  CustomTableViewCell.h
//  to_do_app
//
//  Created by Mina on 17/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end

NS_ASSUME_NONNULL_END
