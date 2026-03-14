"
Examples for GtLChatRegistryDropdown using BlScripter.
"
Class {
	#name : #GtLWorldChatRegistryDropdownExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #examples }
GtLWorldChatRegistryDropdownExamples >> dropdownUpdatesAfterAddingChat [
	<gtExample>
	<return: #BlScripter>
	| registry dropdown scripter |
	registry := GtLChatRegistry new.
	registry newChat.
	dropdown := GtLWorldChatRegistryDropdown new registry: registry; yourself.
	scripter := BlScripter new
		model: registry;
		element: dropdown.

	scripter click
		label: 'Open chats dropdown';
		/ BrButton;
		play.

	scripter assert
		label: 'List starts with one chat';
		value: [ :aList | aList items size ] equals: 1;
		onSpaceRoot;
		// BrColumnedList;
		play.

	scripter do
		block: [ registry newChat ];
		play.

	self 
		assert: (scripter space root query // GtPhlowCellElement) result size
		equals: 6.
	
	scripter assert
		label: 'List updates to two chats';
		value: [ :aList | aList items size ] equals: 2;
		onSpaceRoot;
		// BrColumnedList;
		play.

	^ scripter
]

{ #category : #examples }
GtLWorldChatRegistryDropdownExamples >> dropdownWithChats [
	<gtExample>
	<return: #BlScripter>
	| registry dropdown scripter |
	registry := GtLChatRegistry new.
	
	registry newChat.
	registry newChat.
	
	dropdown := GtLWorldChatRegistryDropdown new 
		registry: registry; yourself.
	scripter := BlScripter new
		model: registry;
		element: dropdown.

	scripter click
		label: 'Open chats dropdown';
		/ BrButton;
		play.

	scripter assert
		label: 'List shows two chats';
		value: [ :aList | aList items size ] equals: 2;
		onSpaceRoot;
		// BrColumnedList;
		play.

	^ scripter
]
