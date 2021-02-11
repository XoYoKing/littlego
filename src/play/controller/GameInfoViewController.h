// -----------------------------------------------------------------------------
// Copyright 2011-2015 Patrick Näf (herzbube@herzbube.ch)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------------


// Project includes
#import "../../settings/EditPlayerProfileController.h"
#import "../../ui/TableViewGridCell.h"

// Forward declarations
@class GameInfoViewController;


// -----------------------------------------------------------------------------
/// @brief The GameInfoViewControllerCreator protocol is used by
/// GameInfoViewController to notify its creator when it is about to be
/// deallocated. The creator thus gets a chance to remove its reference to
/// the GameInfoViewController object.
// -----------------------------------------------------------------------------
@protocol GameInfoViewControllerCreator
- (void) gameInfoViewControllerWillDeallocate:(GameInfoViewController*)gameInfoViewController;
@end


// -----------------------------------------------------------------------------
/// @brief The GameInfoViewController class is responsible for managing user
/// interaction on the "Game Info" view.
// -----------------------------------------------------------------------------
@interface GameInfoViewController : UIViewController <UITableViewDelegate,
                                                      UITableViewDataSource,
                                                      TableViewGridCellDelegate,
                                                      EditPlayerProfileDelegate>
{
}

@property(nonatomic, assign) id<GameInfoViewControllerCreator> gameInfoViewControllerCreator;

@end
