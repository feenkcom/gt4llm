Class {
	#name : #GtLlmReificationForm,
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
GtLlmReificationForm class >> isAdditionForm [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> commit [
	| newTutor newMessages |
	newTutor := self tutorSuperclass asClass
			subclass: self tutorClassName
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: 'Unclassified'.
	newMessages := self messageSuperclass asClass
			subclass: self messageClassName
			instanceVariableNames: ''
			classVariableNames: ''
			poolDictionaries: ''
			package: 'Unclassified'.

	newTutor
		compile: 'messageClass
	^ ' , newMessages name.

	newTutor adoptInstance: self message chat tutor
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> contextMenuItemsForSuperclass [
	^ {'Browse references'
			-> [ :aBrEditor | aBrEditor phlow spawnObject: aBrEditor text asString asClass gtReferences ]}
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> defaultMessageClassName [
	^ 'MessageClass'
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> defaultTutorClassName [
	^ 'TutorClass'
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> initialize [
	super initialize.
	
	self messageClassName: ''.
	self tutorClassName: ''
]

{ #category : #accessing }
GtLlmReificationForm >> message [
	^ message
]

{ #category : #accessing }
GtLlmReificationForm >> message: anObject [
	message := anObject.
	messageSuperclass := message class name.
	tutorSuperclass := message chat tutor class name
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
GtLlmReificationForm >> packageAndTagDescription [
	<magritteDescription>
	^ super packageAndTagDescription priority: 5
]

{ #category : #accessing }
GtLlmReificationForm >> tutorClassName [
	^ tutorClassName
]

{ #category : #accessing }
GtLlmReificationForm >> tutorClassName: anObject [
	tutorClassName := anObject
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> tutorClassNameRope [
	^ self tutorClassName
		ifEmpty: [ self tutorClassName asRopedText
				attribute: (self ghostTextFor: self defaultTutorClassName) ]
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> tutorClassNameRope: aRope [
	self tutorClassName: aRope asString
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> tutorNameDescription [
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
GtLlmReificationForm >> tutorSuperclass [
	^ tutorSuperclass
]

{ #category : #accessing }
GtLlmReificationForm >> tutorSuperclass: anObject [
	tutorSuperclass := anObject
]

{ #category : #'as yet unclassified' }
GtLlmReificationForm >> tutorSuperclassDescription [
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
