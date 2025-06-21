Class {
	#name : #GtLlmReificationForm,
	#superclass : #GtCreationForm,
	#instVars : [
		'message',
		'messageSuperclass',
		'messageClassName',
		'assistantClassName',
		'assistantSuperClass'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmReificationForm class >> isAdditionForm [
	^ false
]

{ #category : #accessing }
GtLlmReificationForm >> assistantClassName [
	^ assistantClassName
]

{ #category : #accessing }
GtLlmReificationForm >> assistantClassName: anObject [
	assistantClassName := anObject
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> assistantClassNameRope [
	^ self assistantClassName
		ifEmpty: [ self assistantClassName asRopedText
				attribute: (self ghostTextFor: self defaultAssistantClassName) ]
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> assistantClassNameRope: aRope [
	self assistantClassName: aRope asString
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> assistantNameDescription [
	<magritteDescription>
	^ GtMATextDescription new
		label: 'Assistant name';
		beRequired;
		priority: 4;
		accessor: #assistantClassNameRope;
		kind: Object;
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize ];
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		addCondition: [ :aValue | aValue asString trim isNotEmpty ]
			labelled: 'Name cannot be empty';
		addCondition: [ :aValue | (Smalltalk classNamed: aValue asString trim) isNil ]
			labelled: 'Name is already taken';
		addCondition: [ :aValue | aValue size > 0 ifTrue: [ aValue first isUppercase ] ifFalse: [ true ] ]
			labelled: 'First character must be uppercase';
		addCondition: [ :aValue | aValue asString allSatisfy: [ :c | c isAlphaNumeric or: [ c = $_ ] ] ]
			labelled: 'Name must be alphanumeric';
		addCondition: [ :aValue | (aValue = 'TNameOfTrait') not and: [ (aValue = 'NameOfSubclass') not ] ]
			labelled: 'Name cannot be example value'
]

{ #category : #accessing }
GtLlmReificationForm >> assistantSuperClass: anObject [
	assistantSuperClass := anObject
]

{ #category : #accessing }
GtLlmReificationForm >> assistantSuperclass [
	^ assistantSuperClass
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> assistantSuperclassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Assistant superclass';
		priority: 3;
		accessor: #assistantSuperclass;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPharoIndex current classNameTree) ];
		blocShortcuts: [ {BlShortcutWithAction new
					name: 'Browse class';
					description: 'Browses the class indicated by the editor';
					combination: BlKeyCombination primaryB;
					action: [ :anEvent | 
						anEvent target phlow
							spawnTool: (GtClassCoderTool forClass: anEvent target text asString asClass) ].
				BlShortcutWithAction new
					name: 'Inspect class';
					description: 'Inspects the class indicated by the editor';
					combination: BlKeyCombination primaryG;
					action: [ :anEvent | 
						anEvent target phlow
							spawnObject: anEvent target text asString asClass ].
				BlShortcutWithAction new
					name: 'Browse class references';
					description: 'Browses references to the class indicated by the editor';
					combination: BlKeyCombination primaryN;
					action: [ :anEvent | 
						anEvent target phlow
							spawnObject: anEvent target text asString asClass gtReferences ]} ];
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize+ (BrGlamorousWithExplicitContextMenuAptitude itemsWithAnchorActions: [ self contextMenuItemsForSuperclass ]) ];
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNotNil ]
			labelled: 'Unknown class';
		addCondition: [ :aValue | 
			| aClass |
			aClass := Smalltalk classNamed: aValue trim.
			aClass isNil or: [ aClass isClass ] ]
			labelled: 'Must be a class';
		addCondition: [ :aValue | 
			| aClass |
			aClass := Smalltalk classNamed: aValue trim.
			aClass isNil or: [ aClass isInstanceSide ] ]
			labelled: 'Must be an instance-side class';
		beRequired
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> commit [
	| newAssistant newMessages package |
	package := self commitPackage.
	newAssistant := self assistantSuperclass asClass
			subclass: self assistantClassName
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: package categoryName asString.
	newMessages := self messageSuperclass asClass
			subclass: self messageClassName
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: package categoryName asString.

	self installMethodsOnMessages: newMessages andAssistant: newAssistant.
	self installActionsOn: newAssistant.
	self installFormatComponentsOn: newAssistant.
	newAssistant adoptInstance: self message chat assistant.
	self message chat provider assistantMessageClass: newMessages.
	self message chat provider userMessageClass: newMessages.
	self message chat messages
		do: [ :aMessage | newMessages adoptInstance: aMessage ]
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> contextMenuItemsForSuperclass [
	^ {'Browse references'
			-> [ :aBrEditor | aBrEditor phlow spawnObject: aBrEditor text asString asClass gtReferences ]}
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> defaultAssistantClassName [
	^ 'AssistantClass'
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> defaultMessageClassName [
	^ 'MessageClass'
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> initialize [
	super initialize.
	
	self messageClassName: ''.
	self assistantClassName: ''
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> installActionsOn: newTutor [
	self message chat assistant actions
		do: [ :action | 
			(action definingMethod hasPragmaNamed: #gtLlmAssistantAction)
				ifFalse: [ newTutor
						compile: 'gt' , (action name asCamelCase select: #isAlphaNumeric)
								, 'Action
	<gtLlmAssistantAction>
	^ ' , action asExpressionSource ] ]
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> installFormatComponentsOn: newTutor [
	self message chat assistant formatComponents
		do: [ :formatComponent | 
			(formatComponent definingMethod hasPragmaNamed: #gtLlmAssistantFormat)
				ifFalse: [ newTutor
						compile: 'gt' , formatComponent name asCamelCase
								, 'FormatDescription
	<gtLlmAssistantFormat>
	^ ' , formatComponent asExpressionSource ] ]
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> installMethodsOnMessages: newMessages andAssistant: newAssistant [
	newAssistant
		compile: 'treatProvider: aProvider
	super treatProvider: aProvider.
	
	aProvider
		assistantMessageClass: ' , newMessages name
				, ';
		userMessageClass: ' , newMessages name.

	newAssistant
		compile: 'defaultDescription
	^ ''' , self message chat assistant description , ''''
]

{ #category : #accessing }
GtLlmReificationForm >> message [
	^ message
]

{ #category : #accessing }
GtLlmReificationForm >> message: anObject [
	message := anObject.
	messageSuperclass := message class name.
	assistantSuperClass := message chat assistant class name
]

{ #category : #accessing }
GtLlmReificationForm >> messageClassName [
	^ messageClassName
]

{ #category : #accessing }
GtLlmReificationForm >> messageClassName: anObject [
	messageClassName := anObject
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> messageClassNameRope [
	^ self messageClassName
		ifEmpty: [ self messageClassName asRopedText
				attribute: (self ghostTextFor: self defaultMessageClassName) ]
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> messageClassNameRope: aRope [
	self messageClassName: aRope asString
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> messageNameDescription [
	<magritteDescription>
	^ GtMATextDescription new
		label: 'Message name';
		beRequired;
		priority: 2;
		accessor: #messageClassNameRope;
		kind: Object;
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize ];
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		addCondition: [ :aValue | aValue asString trim isNotEmpty ]
			labelled: 'Name cannot be empty';
		addCondition: [ :aValue | (Smalltalk classNamed: aValue asString trim) isNil ]
			labelled: 'Name is already taken';
		addCondition: [ :aValue | aValue size > 0 ifTrue: [ aValue first isUppercase ] ifFalse: [ true ] ]
			labelled: 'First character must be uppercase';
		addCondition: [ :aValue | aValue asString allSatisfy: [ :c | c isAlphaNumeric or: [ c = $_ ] ] ]
			labelled: 'Name must be alphanumeric';
		addCondition: [ :aValue | (aValue = 'TNameOfTrait') not and: [ (aValue = 'NameOfSubclass') not ] ]
			labelled: 'Name cannot be example value'
]

{ #category : #accessing }
GtLlmReificationForm >> messageSuperclass [
	^ messageSuperclass
]

{ #category : #accessing }
GtLlmReificationForm >> messageSuperclass: anObject [
	messageSuperclass := anObject
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> messageSuperclassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Message superclass';
		priority: 1;
		accessor: #messageSuperclass;
		blocCompletion: [ GtStringsCompletionStrategy new
				completions: (GtPharoIndex current classNameTree) ];
		blocShortcuts: [ {BlShortcutWithAction new
					name: 'Browse class';
					description: 'Browses the class indicated by the editor';
					combination: BlKeyCombination primaryB;
					action: [ :anEvent | 
						anEvent target phlow
							spawnTool: (GtClassCoderTool forClass: anEvent target text asString asClass) ].
				BlShortcutWithAction new
					name: 'Inspect class';
					description: 'Inspects the class indicated by the editor';
					combination: BlKeyCombination primaryG;
					action: [ :anEvent | 
						anEvent target phlow
							spawnObject: anEvent target text asString asClass ].
				BlShortcutWithAction new
					name: 'Browse class references';
					description: 'Browses references to the class indicated by the editor';
					combination: BlKeyCombination primaryN;
					action: [ :anEvent | 
						anEvent target phlow
							spawnObject: anEvent target text asString asClass gtReferences ]} ];
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize+ (BrGlamorousWithExplicitContextMenuAptitude itemsWithAnchorActions: [ (self contextMenuItemsForSuperclass) ]) ];
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		addCondition: [ :aValue | (Smalltalk classNamed: aValue trim) isNotNil ]
			labelled: 'Unknown class';
		addCondition: [ :aValue | 
			| aClass |
			aClass := Smalltalk classNamed: aValue trim.
			aClass isNil or: [ aClass isClass ] ]
			labelled: 'Must be a class';
		addCondition: [ :aValue | 
			| aClass |
			aClass := Smalltalk classNamed: aValue trim.
			aClass isNil or: [ aClass isInstanceSide ] ]
			labelled: 'Must be an instance-side class';
		beRequired
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> packageAndTagDescription [
	<magritteDescription>
	^ super packageAndTagDescription priority: 5
]
