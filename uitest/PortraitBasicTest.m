// -----------------------------------------------------------------------------
// Copyright 2019 Patrick Näf (herzbube@herzbube.ch)
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
#import "UiElementFinder.h"
#import "UiTestDeviceInfo.h"
#import "UiTestHelper.h"
#import "../src/utility/AccessibilityUtility.h"


// -----------------------------------------------------------------------------
/// @brief The PortraitBasicTest class tests a few basic functions when in
/// interface orientation Portrait.
///
/// See the section "Automated UI tests" in the document TESTING for details
/// about how UI testing works.
// -----------------------------------------------------------------------------
@interface PortraitBasicTest : XCTestCase
@property(nonatomic, strong) UiTestDeviceInfo* uiTestDeviceInfo;
@property(nonatomic, strong) UiElementFinder* uiElementFinder;
@property(nonatomic, strong) UiTestHelper* uiTestHelper;
@end


@implementation PortraitBasicTest

#pragma mark - setUp and tearDown

// -----------------------------------------------------------------------------
/// @brief Sets the environment up for a test.
// -----------------------------------------------------------------------------
- (void) setUp
{
  self.continueAfterFailure = NO;

  XCUIApplication* app = [[XCUIApplication alloc] init];
  app.launchArguments = @[uiTestModeLaunchArgument];
  [app launch];

  [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;

  self.uiTestDeviceInfo = [[UiTestDeviceInfo alloc] initWithUiApplication:app];
  self.uiElementFinder = [[UiElementFinder alloc] initWithUiTestDeviceInfo:self.uiTestDeviceInfo];
  self.uiTestHelper = [[UiTestHelper alloc] initWithUiElementFinder:self.uiElementFinder];
}

// -----------------------------------------------------------------------------
/// @brief Tears the environment down after a test.
// -----------------------------------------------------------------------------
- (void) tearDown
{
  self.uiTestHelper = nil;
  self.uiElementFinder = nil;
  self.uiTestDeviceInfo = nil;
}

#pragma mark - Tests

// -----------------------------------------------------------------------------
/// @brief Test that when the app starts up a number of non-board UI elements
/// are present and have the correct state.
// -----------------------------------------------------------------------------
- (void) testUiAreaPlayDefaultState
{
  XCUIApplication* app = [[XCUIApplication alloc] init];

  // Game actions
  XCUIElement* passButton = [self.uiElementFinder findGameActionButton:GameActionPass withUiApplication:app];
  XCTAssertTrue(passButton.enabled);
  XCUIElement* computerPlayButton = [self.uiElementFinder findGameActionButton:GameActionComputerPlay withUiApplication:app];
  XCTAssertTrue(computerPlayButton.enabled);
  XCUIElement* gameInfoButton = [self.uiElementFinder findGameActionButton:GameActionGameInfo withUiApplication:app];
  XCTAssertTrue(gameInfoButton.enabled);
  XCUIElement* moreGameActionsButton = [self.uiElementFinder findGameActionButton:GameActionMoreGameActions withUiApplication:app];
  XCTAssertTrue(moreGameActionsButton.enabled);
  if (self.uiTestDeviceInfo.uiType == UITypePad)
  {
    XCUIElement* movesButton = [self.uiElementFinder findGameActionButton:GameActionMoves withUiApplication:app];
    XCTAssertTrue(movesButton.enabled);

    // Pop up the board position stuff
    [movesButton tap];
  }

  // Board position navigation
  XCUIElement* rewindToStartButton = [self.uiElementFinder findBoardPositionNavigationButton:BoardPositionNavigationButtonRewindToStart withUiApplication:app];
  XCTAssertFalse(rewindToStartButton.enabled);
  XCUIElement* previousButton = [self.uiElementFinder findBoardPositionNavigationButton:BoardPositionNavigationButtonPrevious withUiApplication:app];
  XCTAssertFalse(previousButton.enabled);
  XCUIElement* nextButton = [self.uiElementFinder findBoardPositionNavigationButton:BoardPositionNavigationButtonNext withUiApplication:app];
  XCTAssertFalse(nextButton.enabled);
  XCUIElement* forwardToEndButton = [self.uiElementFinder findBoardPositionNavigationButton:BoardPositionNavigationButtonForwardToEnd withUiApplication:app];
  XCTAssertFalse(forwardToEndButton.enabled);

  // Status view
  XCUIElement* statusLabel = [self.uiElementFinder findStatusLabelWithUiApplication:app];
  XCTAssertTrue([statusLabel.label isEqualToString:@"Game started Black to move"]);  // Newline character is converted to space

  // Board positions
  if (self.uiTestDeviceInfo.uiType == UITypePhone)
  {
    NSArray* boardPositionCells = [self.uiElementFinder findBoardPositionCellsWithUiApplication:app];
    XCTAssertEqual(boardPositionCells.count, 1);
    XCUIElement* firstBoardPositionCell = boardPositionCells[0];

    XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                              doesContentOfBoardPositionCell:firstBoardPositionCell
                              matchBoardPositionLabelContent:@"Handicap: 0, Komi: 7½"
                                    intersectionLabelContent:@"Start of the game"
                                  capturedStonesLabelContent:nil
                                                   moveColor:GoColorNone]);
    XCTAssertTrue(firstBoardPositionCell.selected);
  }
  else if (self.uiTestDeviceInfo.uiType == UITypePhonePortraitOnly)
  {
    XCUIElement* currentBoardPositionView = [self.uiElementFinder findCurrentBoardPositionCellWithUiApplication:app];
    XCTAssertTrue(currentBoardPositionView.exists);

    XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                              doesContentOfBoardPositionCell:currentBoardPositionView
                              matchBoardPositionLabelContent:@"H: 0"
                                    intersectionLabelContent:@"K: 7½"
                                  capturedStonesLabelContent:nil
                                                   moveColor:GoColorNone]);

    [currentBoardPositionView tap];

    NSArray* boardPositionCells = [self.uiElementFinder findBoardPositionCellsWithUiApplication:app];
    XCTAssertEqual(boardPositionCells.count, 1);
    XCUIElement* firstBoardPositionCell = boardPositionCells[0];

    XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                              doesContentOfBoardPositionCell:firstBoardPositionCell
                              matchBoardPositionLabelContent:@"H: 0"
                                    intersectionLabelContent:@"K: 7½"
                                  capturedStonesLabelContent:nil
                                                   moveColor:GoColorNone]);
  }
  else if (self.uiTestDeviceInfo.uiType == UITypePad)
  {
    XCUIElement* currentBoardPositionView = [self.uiElementFinder findCurrentBoardPositionCellWithUiApplication:app];
    XCTAssertTrue(currentBoardPositionView.exists);

    XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                              doesContentOfBoardPositionCell:currentBoardPositionView
                              matchBoardPositionLabelContent:@"Handicap: 0, Komi: 7½"
                                    intersectionLabelContent:@"Start of the game"
                                  capturedStonesLabelContent:nil
                                                   moveColor:GoColorNone]);

    NSArray* boardPositionCells = [self.uiElementFinder findBoardPositionCellsWithUiApplication:app];
    XCTAssertEqual(boardPositionCells.count, 1);
    XCUIElement* firstBoardPositionCell = boardPositionCells[0];

    XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                              doesContentOfBoardPositionCell:firstBoardPositionCell
                              matchBoardPositionLabelContent:@"Handicap: 0, Komi: 7½"
                                    intersectionLabelContent:@"Start of the game"
                                  capturedStonesLabelContent:nil
                                                   moveColor:GoColorNone]);
    XCTAssertTrue(firstBoardPositionCell.selected);
  }
  else
  {
    XCTAssertTrue(false);
  }
}

// -----------------------------------------------------------------------------
/// @brief Test that all UI areas can be activated.
// -----------------------------------------------------------------------------
- (void) testActivateAllUiAreas_NotUiTypePhone
{
  XCUIApplication* app = [[XCUIApplication alloc] init];

  NSArray* uiAreas;
  if (self.uiTestDeviceInfo.uiType == UITypePhonePortraitOnly)
  {
    uiAreas = @[[NSNumber numberWithInt:UIAreaSettings],
                [NSNumber numberWithInt:UIAreaArchive],
                [NSNumber numberWithInt:UIAreaHelp],
                [NSNumber numberWithInt:UIAreaPlay],
                // Last entry so that the first loop ends while the
                // "More" navigation controller is visible
                [NSNumber numberWithInt:UIAreaNavigation]];
  }
  else
  {
    uiAreas = @[[NSNumber numberWithInt:UIAreaSettings],
                [NSNumber numberWithInt:UIAreaArchive],
                [NSNumber numberWithInt:UIAreaHelp],
                [NSNumber numberWithInt:UIAreaDiagnostics],
                [NSNumber numberWithInt:UIAreaAbout],
                [NSNumber numberWithInt:UIAreaSourceCode],
                [NSNumber numberWithInt:UIAreaPlay],
                // Last entry so that the first loop ends while the
                // "More" navigation controller is visible
                [NSNumber numberWithInt:UIAreaNavigation]];
  }

  for (NSNumber* uiAreaAsNumber in uiAreas)
  {
    enum UIArea uiArea = uiAreaAsNumber.intValue;

    XCUIElement* uiAreaElement = [self.uiElementFinder findUiAreaElement:uiArea withUiApplication:app];
    [uiAreaElement tap];

    XCUIElement* uiAreaNavigationBar = [self.uiElementFinder findUiAreaNavigationBar:uiArea withUiApplication:app];
    XCTAssertTrue(uiAreaNavigationBar.exists);
  }

  if (self.uiTestDeviceInfo.uiType == UITypePhonePortraitOnly)
  {
    uiAreas = @[[NSNumber numberWithInt:UIAreaDiagnostics],
                [NSNumber numberWithInt:UIAreaAbout],
                [NSNumber numberWithInt:UIAreaSourceCode],
                [NSNumber numberWithInt:UIAreaLicenses],
                [NSNumber numberWithInt:UIAreaCredits],
                [NSNumber numberWithInt:UIAreaChangelog]];
  }
  else
  {
    uiAreas = @[[NSNumber numberWithInt:UIAreaLicenses],
                [NSNumber numberWithInt:UIAreaCredits],
                [NSNumber numberWithInt:UIAreaChangelog]];
  }

  for (NSNumber* uiAreaAsNumber in uiAreas)
  {
    enum UIArea uiArea = uiAreaAsNumber.intValue;

    XCUIElement* uiAreaElement = [self.uiElementFinder findUiAreaElement:uiArea withUiApplication:app];
    [uiAreaElement tap];

    XCUIElement* uiAreaNavigationBar = [self.uiElementFinder findUiAreaNavigationBar:uiArea withUiApplication:app];
    XCTAssertTrue(uiAreaNavigationBar.exists);

    XCUIElement* backButton = [self.uiElementFinder findBackButtonMoreFromUiAreaNavigationBar:uiAreaNavigationBar];
    [backButton tap];

    XCUIElement* moreNavigationBar = [self.uiElementFinder findUiAreaNavigationBar:UIAreaNavigation withUiApplication:app];
    XCTAssertTrue(moreNavigationBar.exists);
  }
}

// -----------------------------------------------------------------------------
/// @brief Test that when the app starts up a number of board UI elements
/// are present.
// -----------------------------------------------------------------------------
- (void) testBoardDefaultState
{
  XCUIApplication* app = [[XCUIApplication alloc] init];

  enum GoBoardSize boardSize = GoBoardSize9;

  UIAccessibilityElement* boardSizeAccessibilityElement = [AccessibilityUtility uiAccessibilityElementInContainer:self forBoardSize:boardSize];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                                matchingUiElementExistsFor:boardSizeAccessibilityElement]);

  UIAccessibilityElement* starPointsAccessibilityElement =
    [AccessibilityUtility uiAccessibilityElementInContainer:self forStarPointVertexes:@[@"C3", @"G3", @"C7", @"G7"]];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                                matchingUiElementExistsFor:starPointsAccessibilityElement]);

  UIAccessibilityElement* handicapPointsAccessibilityElement =
    [AccessibilityUtility uiAccessibilityElementInContainer:self forHandicapPointVertexes:@[]];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                                matchingUiElementDoesNotExistFor:handicapPointsAccessibilityElement]);

  UIAccessibilityElement* blackStonePointsAccessibilityElement =
    [AccessibilityUtility uiAccessibilityElementInContainer:self
                                      forStonePointVertexes:@[]
                                                  withColor:GoColorBlack];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                          matchingUiElementDoesNotExistFor:blackStonePointsAccessibilityElement]);

  UIAccessibilityElement* whiteStonePointsAccessibilityElement =
    [AccessibilityUtility uiAccessibilityElementInContainer:self
                                      forStonePointVertexes:@[]
                                                  withColor:GoColorWhite];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                          matchingUiElementDoesNotExistFor:whiteStonePointsAccessibilityElement]);

  UIAccessibilityElement* lineGridAccessibilityElement = [AccessibilityUtility uiAccessibilityElementInContainer:self forLineGridWithSize:boardSize];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                                matchingUiElementExistsFor:lineGridAccessibilityElement]);
}

// -----------------------------------------------------------------------------
/// @brief Test that a stone can be placed and the computer player responds with
/// the correct move.
// -----------------------------------------------------------------------------
- (void) testBoardCanPlayAndComputerResponds
{
  XCUIApplication* app = [[XCUIApplication alloc] init];

  enum GoBoardSize boardSize = GoBoardSize9;

  UIAccessibilityElement* blackStonePointsAccessibilityElement =
  [AccessibilityUtility uiAccessibilityElementInContainer:self
                                    forStonePointVertexes:@[@"C8"]
                                                withColor:GoColorBlack];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                          matchingUiElementDoesNotExistFor:blackStonePointsAccessibilityElement]);

  UIAccessibilityElement* whiteStonePointsAccessibilityElement =
  [AccessibilityUtility uiAccessibilityElementInContainer:self
                                    forStonePointVertexes:@[@"F3"]
                                                withColor:GoColorWhite];
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                          matchingUiElementDoesNotExistFor:whiteStonePointsAccessibilityElement]);

  [self.uiTestHelper tapIntersection:@"C8"
                     onBoardWithSize:boardSize
                   withUiApplication:app];

  // Wait for the computer player to respond. The opening book is responsible
  // for it to make the expected move.
  [self.uiTestHelper waitWithUiApplication:app
                        onBehalfOfTestCase:self
                forExistsMatchingUiElement:whiteStonePointsAccessibilityElement];

  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                                matchingUiElementExistsFor:blackStonePointsAccessibilityElement]);
  XCTAssertTrue([self.uiTestHelper verifyWithUiApplication:app
                                matchingUiElementExistsFor:whiteStonePointsAccessibilityElement]);
}

@end
