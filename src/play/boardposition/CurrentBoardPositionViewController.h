// -----------------------------------------------------------------------------
// Copyright 2013-2021 Patrick Näf (herzbube@herzbube.ch)
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


// Forward declarations
@class CurrentBoardPositionViewController;
@class BoardPositionView;


// -----------------------------------------------------------------------------
/// @brief The CurrentBoardPositionViewControllerDelegate protocol must be
/// implemented by the delegate of CurrentBoardPositionViewController.
// -----------------------------------------------------------------------------
@protocol CurrentBoardPositionViewControllerDelegate
- (void) didTapCurrentBoardPositionViewController:(CurrentBoardPositionViewController*)controller;
@end


// -----------------------------------------------------------------------------
/// @brief The CurrentBoardPositionViewController class is responsible for
/// managing the BoardPositionView in #UIAreaPlay that displays information
/// about the current board position.
///
/// CurrentBoardPositionViewController is a child view controller. It is used
/// for #UITypePhonePortraitOnly only.
///
/// CurrentBoardPositionViewController has the following responsibilities:
/// - Tell the current board position view to update itself when the current
///   board position changes.
/// - Detect a tap gesture on the current board position view. The actual
///   handling of the gesture is delegated to the
///   CurrentBoardPositionViewControllerDelegate object that previously must
///   have been set.
// -----------------------------------------------------------------------------
@interface CurrentBoardPositionViewController : UIViewController <UIGestureRecognizerDelegate>
{
}

@property(nonatomic, assign) id<CurrentBoardPositionViewControllerDelegate> delegate;
@property(nonatomic, retain) BoardPositionView* boardPositionView;

@end
