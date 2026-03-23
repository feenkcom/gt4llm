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
	registry newChat.
	self assert: scripter chatCount: 1.
	registry newChat.
	self assert: scripter chatCount: 2.
	registry newChat.
	self assert: scripter chatCount: 3.
	^ scripter
]

{ #category : #examples }
GtLRegistryListElementExamples >> registryListUpdatesWhenChatsAreAdded_removeOneChat [
	<gtExample>
	| scripter |
	scripter := self registryListUpdatesWhenChatsAreAdded.

	scripter menuStep
		openContextMenu;
		// #scrollable;
		onChildAt: 2;
		play.

	^ scripter
]
