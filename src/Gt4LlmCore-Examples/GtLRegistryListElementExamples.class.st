"
I contain examples for GtLRegistryListElement.
"
Class {
	#name : #GtLRegistryListElementExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-UI'
}

{ #category : #examples }
GtLRegistryListElementExamples >> assert: scripter chatCount: aCount [
	scripter wait
		for: [ (scripter element query // #scrollable) anyOne childrenCount = aCount ]
			timeout: 5 seconds;
		play.
	self assert: scripter model chats size equals: aCount.
	self
		assert: (scripter element query // #scrollable) anyOne childrenCount
		equals: aCount
]

{ #category : #examples }
GtLRegistryListElementExamples >> registryListUpdatesWhenChatsAreAdded [
	<gtExample>
	| registry element scripter |
	registry := GtLChatRegistry new.
	element := GtLChatRegistryListElement new registryViewModel: registry asViewModel.
	scripter := BlScripter new
			element: element;
			model: registry.
	scripter pulse.
	self assert: scripter chatCount: 0.
	registry newChatWithProvider: GtLOpenAIProviderStub new.
	self assert: scripter chatCount: 1.
	registry newChatWithProvider: GtLOpenAIProviderStub new.
	self assert: scripter chatCount: 2.
	registry newChatWithProvider: GtLOpenAIProviderStub new.
	self assert: scripter chatCount: 3.
	^ scripter
]

{ #category : #examples }
GtLRegistryListElementExamples >> registryListUpdatesWhenChatsAreAdded_removeOneChat [
	<gtExample>
	| scripter anItemId |
	scripter := self registryListUpdatesWhenChatsAreAdded.

	anItemId := #'registry-chat' asBlocElementId indexed: 2.
	scripter menuStep
		openContextMenu;
		assertMenuContainerExist;
		// anItemId;
		play.

	scripter menuStep
		hoverMenuItemWithId: #'chat--remove';
		clickMenuItemWithId: #'chat--remove';
		onPopover;
		play.

	self assert: scripter chatCount: 2.
		
	^ scripter
]

{ #category : #examples }
GtLRegistryListElementExamples >> registryListUpdatesWhenChatsAreAdded_removeTwoChats [
	<gtExample>
	| scripter anItemAId anItemBId |
	scripter := self registryListUpdatesWhenChatsAreAdded.

	anItemAId := #'registry-chat' asBlocElementId indexed: 2.
	anItemBId := #'registry-chat' asBlocElementId indexed: 3.

	scripter click
		// anItemAId;
		play.
	scripter click
		modifiers: BlKeyModifiers shift;
		// anItemBId;
		play.

	self
		assert: (scripter element query // BrColumnedList) anyOne selectedItems size
		equals: 2.

	scripter menuStep
		openContextMenu;
		assertMenuContainerExist;
		// anItemAId;
		play.

	scripter menuStep
		hoverMenuItemWithId: #'chat--remove';
		clickMenuItemWithId: #'chat--remove';
		onPopover;
		play.

	self assert: scripter chatCount: 1.

	^ scripter
]
