"
Examples for GtLChatRegistryDropdown using BlScripter.
"
Class {
	#name : #GtLChatRegistryDropdownExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #examples }
GtLChatRegistryDropdownExamples >> dropdownUpdatesAfterAddingChat [
	<gtExample>
	<return: #BlScripter>
	| registry dropdown scripter |
	registry := GtLChatRegistry new.
	registry newChat.
	dropdown := GtLChatRegistryDropdown new registry: registry; yourself.
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

	registry newChat.

	scripter assert
		label: 'List updates to two chats';
		value: [ :aList | aList items size ] equals: 2;
		onSpaceRoot;
		// BrColumnedList;
		play.

	^ scripter
]

{ #category : #examples }
GtLChatRegistryDropdownExamples >> dropdownWithChats [
	<gtExample>
	<return: #BlScripter>
	| registry dropdown scripter |
	registry := GtLChatRegistry new.
	registry newChat.
	registry newChat.
	dropdown := GtLChatRegistryDropdown new registry: registry; yourself.
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
