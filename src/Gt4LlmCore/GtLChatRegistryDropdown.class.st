"
I provide a dropdown button that shows the chats registered in a GtLChatRegistry.
"
Class {
	#name : #GtLChatRegistryDropdown,
	#superclass : #BrFrame,
	#instVars : [
		'registry',
		'dropdownElement',
		'currentDropdownContent',
		'listElement'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #private }
GtLChatRegistryDropdown >> dropdownContent [
	^ currentDropdownContent ifNil: [ currentDropdownContent := self newDropdownContent ]
]

{ #category : #accessing }
GtLChatRegistryDropdown >> dropdownElement [
	^ dropdownElement
]

{ #category : #initialization }
GtLChatRegistryDropdown >> initialize [
	super initialize.
	
	self viewModel: BrWidgetModel new.
	self hFitContent.
	self vFitContent.
	
	self initializeDropdownElement.
	self addChild: self dropdownElement as: #dropdown.
	self addAptitude: (BrLayoutResizerAptitude new anyToFitContent: self).
	
	self dropdownElement 
		when: GtPhlowObjectToSpawn 
		do: [ :anEvent | 
			anEvent isConsumed ifFalse: [
					self phlow spawnOrShowObject: anEvent object ] ]
]

{ #category : #initialization }
GtLChatRegistryDropdown >> initializeDropdownElement [
	dropdownElement := self newButton
		label: self tooltip;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
			handle: [ self newDropdownButton ]
			content: [ self reusedDropdownContent ])
]

{ #category : #private }
GtLChatRegistryDropdown >> newButton [
	^ BrButton new
		id: #'chat-registry--button';
		icon: BrGlamorousVectorIcons chat;
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
]

{ #category : #private }
GtLChatRegistryDropdown >> newDropdownButton [
	^ BrButton new
		icon: BrGlamorousVectorIcons chat;
		label: self tooltip;
		aptitude: BrGlamorousButtonWithIconAptitude
			- BrGlamorousButtonWithLabelTooltipAptitude2
			- BrGlamorousButtonExteriorAptitude
]

{ #category : #private }
GtLChatRegistryDropdown >> newDropdownContent [
	| container |
	container := BrFrame new exact: 600@400.
	listElement := self newListElement.
	container addChild: listElement.
	container addAptitude:  (BrGlamorousWithVerticalResizerAptitude
				+ BrGlamorousWithHorizontalResizerAptitude new beLeft).
	^ container
]

{ #category : #private }
GtLChatRegistryDropdown >> newListElement [
	^ ((self registry gtViewChatsOn: GtPhlowEmptyView new))
		asElementDo: [ :element |element ]
]

{ #category : #accessing }
GtLChatRegistryDropdown >> registry [
	^ registry ifNil: [
			registry := GtLChatRegistry current.]
]

{ #category : #accessing }
GtLChatRegistryDropdown >> registry: aRegistry [
	registry := aRegistry
]

{ #category : #private }
GtLChatRegistryDropdown >> reusedDropdownContent [
	| dropdown |
	dropdown := self dropdownContent.
	^ dropdown removeFromParent
]

{ #category : #accessing }
GtLChatRegistryDropdown >> tooltip [
	^ 'Chats'
]
