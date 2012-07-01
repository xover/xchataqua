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

#import "SGHBoxView.h"

@implementation SGHBoxView

- (id) initWithFrame:(NSRect) frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		[self setOrientation:SGBoxOrientationHorizontal];
		self.hJustification = SGHBoxHJustificationLeft;
		[self setDefaultVJustification:SGHBoxVJustificationCenter];
	}
	return self;
}

- (void) setHJustification:(SGHBoxHJustification) aJustification
{
	[self setMajorJustification:(SGBoxMajorJustification)aJustification];
}

- (SGHBoxHJustification) hJustification
{
	return (SGHBoxHJustification)[self majorJustification];
}

- (void) setDefaultVJustification:(SGHBoxVJustification) aJustification
{
	[self setMinorDefaultJustification:(SGBoxMinorJustification)aJustification];
}

- (SGHBoxVJustification) vJustification
{
	return (SGHBoxVJustification)minorJustification;
}

- (void) setVJustificationFor:(NSView *) view to:(SGHBoxVJustification) aJustification
{
	[self setMinorJustificationFor:view to:(SGBoxMinorJustification)aJustification];
}

- (void) setVMargin:(SGBoxMargin) v
{
	[self setMinorMargin:v];
}

- (SGBoxMargin) vMargin {
	return minorMargin;
}

- (void) setHInnerMargin:(SGBoxMargin) h
{
	[self setMajorInnerMargin:h];
}

- (SGBoxMargin) hInnerMargin
{
	return [self majorInnerMargin];
}

- (void) setHOutterMargin:(SGBoxMargin) h
{
	[self setMajorOutterMargin:h];
}

- (SGBoxMargin) hOutterMargin
{
	return [self majorOutterMargin];
}

/*
 * Called whenever App Kit thinks the rectangle representing our NSView is
 * dirty and needs to be redrawn, including the initial setup.
 *
 * By drawing a filled rectangle within the bounds of ourselves, we effectively
 * set the background despite NSView not really supporting that.
 *
 * FIXME: This should really be handled by our base class (SGView).
 *
 */
- (void) drawRect:(NSRect) aRect
{
    // ???: Do we strictly need to call to super here?
	[super drawRect:aRect];
	
    [[NSColor windowBackgroundColor] setFill]; // The system window background
	[[NSGraphicsContext currentContext] setShouldAntialias:false];
	NSBezierPath *p = [NSBezierPath bezierPathWithRect:[self bounds]];
	[p fill];
#if 0
    // For debugging
    [p setLineWidth:5];
	[p stroke];
#endif
}

@end
