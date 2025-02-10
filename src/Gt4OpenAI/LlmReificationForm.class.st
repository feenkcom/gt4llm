Class {
	#name : #LlmReificationForm,
	#superclass : #GtCreationForm,
	#instVars : [
		'message',
		'messageSuperclass',
		'tutorSuperclass',
		'messageClassName',
		'tutorClassName'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #'as yet unclassified' }
LlmReificationForm class >> isAdditionForm [
	^ false
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> commit [
	| newTutor newMessages package |
	package := self commitPackage.
	newTutor := self tutorSuperclass asClass
			subclass: self tutorClassName
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

	self installMethodsOnMessages: newMessages andTutor: newTutor.
	self installActionsOn: newTutor.
	self installFormatComponentsOn: newTutor.
	newTutor adoptInstance: self message chat tutor.
	self message chat messages
		do: [ :aMessage | newMessages adoptInstance: aMessage ]
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> contextMenuItemsForSuperclass [
	^ {'Browse references'
			-> [ :aBrEditor | aBrEditor phlow spawnObject: aBrEditor text asString asClass gtReferences ]}
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> defaultMessageClassName [
	^ 'MessageClass'
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> defaultTutorClassName [
	^ 'TutorClass'
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> initialize [
	super initialize.
	
	self messageClassName: ''.
	self tutorClassName: ''
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> installActionsOn: newTutor [
	self message chat tutor actions
		do: [ :action | 
			(action definingMethod hasPragmaNamed: #gtLlmTutorAction)
				ifFalse: [ newTutor
						compile: 'gt' , (action name asCamelCase select: #isAlphaNumeric)
								, 'Action
	<gtLlmFormatComponent>
	^ ' , action asExpressionSource ] ]
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> installFormatComponentsOn: newTutor [
	self message chat tutor formatComponents
		do: [ :formatComponent | 
			(formatComponent definingMethod hasPragmaNamed: #gtLlmTutorFormat)
				ifFalse: [ newTutor
						compile: 'gt' , formatComponent name asCamelCase
								, 'FormatDescription
	<gtLlmTutorFormat>
	^ ' , formatComponent asExpressionSource ] ]
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> installMethodsOnMessages: newMessages andTutor: newTutor [
	newTutor
		compile: 'defaultProviderStencil
	^ [:aValue | (super defaultProviderStencil value: aValue) assistantMessageClass: '
				, newMessages name , '; userMessageClass: ' , newMessages name , ' ]'
]

{ #category : #accessing }
LlmReificationForm >> message [
	^ message
]

{ #category : #accessing }
LlmReificationForm >> message: anObject [
	message := anObject.
	messageSuperclass := message class name.
	tutorSuperclass := message chat tutor class name
]

{ #category : #accessing }
LlmReificationForm >> messageClassName [
	^ messageClassName
]

{ #category : #accessing }
LlmReificationForm >> messageClassName: anObject [
	messageClassName := anObject
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> messageClassNameRope [
	^ self messageClassName
		ifEmpty: [ self messageClassName asRopedText
				attribute: (self ghostTextFor: self defaultMessageClassName) ]
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> messageClassNameRope: aRope [
	self messageClassName: aRope asString
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> messageNameDescription [
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
LlmReificationForm >> messageSuperclass [
	^ messageSuperclass
]

{ #category : #accessing }
LlmReificationForm >> messageSuperclass: anObject [
	messageSuperclass := anObject
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> messageSuperclassDescription [
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
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize+ (BrGlamorousWithContextMenuAptitude
								content: [ BrGlamorousSimpleContextMenuContent new
										items: (self contextMenuItemsForSuperclass) ]) ];
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
LlmReificationForm >> packageAndTagDescription [
	<magritteDescription>
	^ super packageAndTagDescription priority: 5
]

{ #category : #accessing }
LlmReificationForm >> tutorClassName [
	^ tutorClassName
]

{ #category : #accessing }
LlmReificationForm >> tutorClassName: anObject [
	tutorClassName := anObject
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> tutorClassNameRope [
	^ self tutorClassName
		ifEmpty: [ self tutorClassName asRopedText
				attribute: (self ghostTextFor: self defaultTutorClassName) ]
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> tutorClassNameRope: aRope [
	self tutorClassName: aRope asString
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> tutorNameDescription [
	<magritteDescription>
	^ GtMATextDescription new
		label: 'Tutor name';
		beRequired;
		priority: 4;
		accessor: #tutorClassNameRope;
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
LlmReificationForm >> tutorSuperclass [
	^ tutorSuperclass
]

{ #category : #accessing }
LlmReificationForm >> tutorSuperclass: anObject [
	tutorSuperclass := anObject
]

{ #category : #'as yet unclassified' }
LlmReificationForm >> tutorSuperclassDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Tutor superclass';
		priority: 3;
		accessor: #tutorSuperclass;
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
		editorAptitude: [ BrGlamorousRegularEditorAptitude new glamorousFormEditorCodeFontAndSize+ (BrGlamorousWithContextMenuAptitude
								content: [ BrGlamorousSimpleContextMenuContent new
										items: (self contextMenuItemsForSuperclass) ]) ];
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
