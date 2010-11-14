/* X-Chat Aqua
 * Copyright (C) 2002 Steve Green
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA */

#include "../common/xchat.h"
#include "../common/xchatc.h"

#import "AquaChat.h"
#import "ChatWindow.h"
#import "AsciiWindow.h"

//////////////////////////////////////////////////////////////////////

@implementation AsciiWindow

- (id) init {
	#define AWBWidth  30.0f
	#define AWBHeight 30.0f
	#define AWLWidth  30.0f
	#define AWMargin  20.0f
	#define AWColCount 16

	NSRect windowRect = NSMakeRect (0.0f, 0.0f,
								   AWColCount * AWBWidth + AWMargin + AWMargin + AWLWidth,
								   AWColCount * AWBHeight + AWMargin + AWMargin);

	self = [super initWithContentRect:windowRect 
							styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
							  backing:NSBackingStoreBuffered
								defer:NO];
	
	if ( self != nil ) {
		NSView *asciiView = [[NSView alloc] initWithFrame:windowRect];
	
		for (NSInteger y = 0; y < AWColCount; y ++)
		{
			NSTextField *lineTextField = [[NSTextField alloc] init];
			[lineTextField setEditable:NO];
			[lineTextField setBezeled:NO];
			[lineTextField setBordered:NO];
			[lineTextField setDrawsBackground:NO];
			[lineTextField setAlignment:NSRightTextAlignment];
			[lineTextField setTitleWithMnemonic:[NSString stringWithFormat:@"%03d", y * AWColCount]];
			[lineTextField sizeToFit];
			NSRect lineFrame = [lineTextField frame];
			NSPoint lineOrigin = NSMakePoint (AWMargin + AWLWidth - lineFrame.size.width - 5.0f, 
											  windowRect.size.height - AWMargin - y * AWBHeight - AWBHeight + (AWBHeight - lineFrame.size.height) / 2);
			[lineTextField setFrameOrigin:lineOrigin];
			[asciiView addSubview:lineTextField];
			[lineTextField release];
			
			for (NSInteger x = 0; x < AWColCount; x ++)
			{
				unichar character = y * AWColCount + x;
				
				NSRect buttonRect = NSMakeRect (AWMargin + AWLWidth + x * AWBWidth, windowRect.size.height - AWMargin - y * AWBHeight - AWBHeight, AWBWidth, AWBHeight);
				NSButton *characterButton = [[NSButton alloc] initWithFrame:buttonRect];
				[characterButton setBezelStyle:NSShadowlessSquareBezelStyle];
				[characterButton setButtonType:NSMomentaryPushButton];
				[characterButton setTitle:[NSString stringWithFormat:@"%c", character]];
				[characterButton setAction:@selector(onInput:)];
				[characterButton setTarget:self];
				[characterButton setTag:character];
				[characterButton setImagePosition:NSNoImage];
				[asciiView addSubview:characterButton];
				[characterButton release];
			}
		}
	
		[self setReleasedWhenClosed:NO];
		[self setContentView:asciiView];
		[self setTitle:NSLocalizedStringFromTable(@"Character Chart", @"xchat", @"")];
		[self center];
		[asciiView release];
	}
	return self;
}

- (void) onInput:(id) sender
{
	if (current_sess)
		[current_sess->gui->cw insertText:[sender title]];
}

@end
