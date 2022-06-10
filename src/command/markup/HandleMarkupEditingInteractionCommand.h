// -----------------------------------------------------------------------------
// Copyright 2022 Patrick Näf (herzbube@herzbube.ch)
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
#import "../CommandBase.h"

// Forward declarations
@class GoPoint;


// -----------------------------------------------------------------------------
/// @brief The HandleMarkupEditingInteractionCommand class is responsible for
/// handling a markup editing interaction at the intersection identified by the
/// GoPoint object that is passed to the initializer.
///
/// After it has processed the markup editing interaction,
/// HandleMarkupEditingInteractionCommand saves the application state and
/// performs a backup of the current game.
///
/// It is expected that this command is only executed while the UI area "Play"
/// is in markup editing mode and the current board position is not 0. If any
/// of these conditions is not met an alert is displayed and command execution
/// fails.
// -----------------------------------------------------------------------------
@interface HandleMarkupEditingInteractionCommand : CommandBase
{
}

- (id) initWithPoint:(GoPoint*)point;

@end
