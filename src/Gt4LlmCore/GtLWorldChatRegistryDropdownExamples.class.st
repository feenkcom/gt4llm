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
	registry newChatWithProvider: GtLOpenAIProviderStub new.
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
		block: [ registry newChatWithProvider: GtLOpenAIProviderStub new ];
		play.

	self 
		assert: (scripter space root query // BrColumnedList / #scrollable ) anyOne childrenCount
		equals: 2.
	
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
	
	registry newChatWithProvider: GtLOpenAIProviderStub new.
	registry newChatWithProvider: GtLOpenAIProviderStub new.
	
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
