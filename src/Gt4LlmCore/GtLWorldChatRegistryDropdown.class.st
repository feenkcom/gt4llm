"
I provide a dropdown button that shows the chats registered in a GtLChatRegistry.
"
Class {
	#name : #GtLWorldChatRegistryDropdown,
	#superclass : #BrFrame,
	#instVars : [
		'registry',
		'dropdownElement',
		'currentDropdownContent',
		'listElement',
		'contentUpdater'
	],
	#category : #'Gt4LlmCore-UI - Registry'
}

{ #category : #callbacks }
GtLWorldChatRegistryDropdown >> actOnWorldRegistryChanged: anAnnouncement [

	self registry: anAnnouncement chatRegistry.
	self requestContentUpdate.
]

{ #category : #private }
GtLWorldChatRegistryDropdown >> dropdownContent [
	^ currentDropdownContent ifNil: [ currentDropdownContent := self newDropdownContent ]
]

{ #category : #accessing }
GtLWorldChatRegistryDropdown >> dropdownElement [
	^ dropdownElement
]

{ #category : #initialization }
GtLWorldChatRegistryDropdown >> initialize [
	super initialize.
	
	self viewModel: BrWidgetModel new.
	self hFitContent.
	self vFitContent.
	
	self initializeDropdownElement.
	self addChild: self dropdownElement as: #dropdown.
	self addAptitude: (BrLayoutResizerAptitude new anyToFitContent: self).
	
	contentUpdater := BrElementUpdater new
		postponedDuration: 100 milliSeconds;
		element: self selector: #updateContent.
	
	self dropdownElement 
		when: GtPhlowObjectToSpawn 
		do: [ :anEvent | 
			anEvent isConsumed ifFalse: [
					self phlow spawnOrShowObject: anEvent object ] ]
]

{ #category : #initialization }
GtLWorldChatRegistryDropdown >> initializeDropdownElement [
	dropdownElement := self newButton
		label: self tooltip;
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
			handle: [ self newDropdownButton ]
			content: [ self reusedDropdownContent ])
]

{ #category : #initialization }
GtLWorldChatRegistryDropdown >> initializeForWorldElement: aWorldElement [

	aWorldElement announcer
		when: GtWorldElementChatRegistryChangedAnnouncement
		send: #actOnWorldRegistryChanged:
		to: self.

	"It is possible to add the element to a world that already has a chat registry"
	self registry: aWorldElement llmChatRegistry
]

{ #category : #private }
GtLWorldChatRegistryDropdown >> newButton [
	^ BrButton new
		id: #'chat-registry--button';
		icon: BrGlamorousVectorIcons emphasizedChat;
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
]

{ #category : #private }
GtLWorldChatRegistryDropdown >> newDropdownButton [
	^ BrButton new
		icon: BrGlamorousVectorIcons emphasizedChat;
		label: self tooltip;
		aptitude: BrGlamorousButtonWithIconAptitude
			- BrGlamorousButtonWithLabelTooltipAptitude2
			- BrGlamorousButtonExteriorAptitude
]

{ #category : #private }
GtLWorldChatRegistryDropdown >> newDropdownContent [
	| container |
	container := BrFrame new exact: 600@400.
	listElement := self newListElement.
	container addChild: listElement.
	container addAptitude:  (BrGlamorousWithVerticalResizerAptitude
				+ BrGlamorousWithHorizontalResizerAptitude new beLeft).
	^ container
]

{ #category : #private }
GtLWorldChatRegistryDropdown >> newListElement [
	| phlowView |
	
	phlowView := self registry 
		ifNil: [ GtPhlowEmptyView new ]
		ifNotNil: [ 
			self registry gtViewChatsOn: GtPhlowEmptyView new ].
		
	^ phlowView asElementDo: [ :element | element ]
]

{ #category : #accessing }
GtLWorldChatRegistryDropdown >> registry [
	^ registry ifNil: [
			registry := GtLChatRegistry current.]
]

{ #category : #accessing }
GtLWorldChatRegistryDropdown >> registry: aRegistry [
	registry := aRegistry
]

{ #category : #updating }
GtLWorldChatRegistryDropdown >> requestContentUpdate [
	contentUpdater ifNotNil: [ :anUpdater | 
		anUpdater requestUpdate ]
]

{ #category : #private }
GtLWorldChatRegistryDropdown >> reusedDropdownContent [
	| dropdown |
	dropdown := self dropdownContent.
	^ dropdown removeFromParent
]

{ #category : #accessing }
GtLWorldChatRegistryDropdown >> tooltip [
	^ 'Chats'
]

{ #category : #updating }
GtLWorldChatRegistryDropdown >> updateContent [ 
	currentDropdownContent ifNil: [ ^ self ].
	currentDropdownContent removeChildren. 
	currentDropdownContent addChild: self newDropdownContent.
]
