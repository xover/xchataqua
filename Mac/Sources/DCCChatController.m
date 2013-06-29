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

#include <dcc.h>

#import "DCCChatController.h"

//////////////////////////////////////////////////////////////////////

@interface DccChatItem : DCCItem
{
    NSString    *toFrom;
    NSString    *recv;
    NSString    *sent;
    NSString    *startTime;
}

@property (nonatomic, retain) NSString *toFrom, *recv, *sent, *startTime;

- (id) initWithDCC:(struct DCC *)dcc;
- (void) update;

@end

@implementation DccChatItem
@synthesize toFrom, recv, sent, startTime;

- (id) initWithDCC:(struct DCC *)aDcc
{
    self = [super initWithDCC:aDcc];
    if (self) {
        [self update];
    }
    return self;
}

- (void) dealloc
{
    self.toFrom   = nil;
    self.recv     = nil;
    self.sent     = nil;
    self.startTime= nil;

    [super dealloc];
}

- (void) update
{
    [super update];
    self.toFrom   = @(dcc->nick);
    self.recv     = [NSString stringWithFormat:@"%"DCC_SIZE_FMT, dcc->pos];
    self.sent     = [NSString stringWithFormat:@"%"DCC_SIZE_FMT, dcc->size];
    self.startTime= @(ctime(&dcc->starttime));
}

@end

//////////////////////////////////////////////////////////////////////

@implementation DCCChatController

- (id) init
{
    self = [super initWithNibNamed:@"DccChat"];
    return self;
}

- (DCCItem *)itemWithDCC:(struct DCC *) dcc
{
    if (dcc->type != TYPE_CHATSEND && dcc->type != TYPE_CHATRECV) return nil;
    
    return [[[DccChatItem alloc] initWithDCC:dcc] autorelease];
}

- (void) awakeFromNib
{
    [super awakeFromNib];

    [dccListView setTitle:NSLocalizedStringFromTable(@"XChat: DCC Chat List", @"xchat", @"")];
    [dccListView setTabTitle:NSLocalizedStringFromTable(@"dccchat", @"xchataqua", @"Title of Tab: MainMenu->Window->DCC Chat...")];
}

- (void) doAccept:(id)sender
{
    NSInteger row = [itemTableView selectedRow];
    if (row != NSNotFound)
    {
        DccChatItem *item = dccItems[row];
        struct DCC *dcc = item->dcc;
        dcc_get(dcc);
    }
}

- (void) add:(struct DCC *) dcc
{
    DccChatItem *item = [[[DccChatItem alloc] initWithDCC:dcc] autorelease];
    [dccItems addObject:item];
    [itemTableView reloadData];
}

#pragma mark NSTableView

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger) rowIndex
{
    DccChatItem *item = dccItems[rowIndex];

    switch ([[aTableView tableColumns] indexOfObjectIdenticalTo:aTableColumn])
    {
        case 0: return [item status];
        case 1: return [item toFrom];
        case 2: return [item recv];
        case 3: return [item sent];
        case 4: return [item startTime];
    }
    
    return @"";
}

@end
