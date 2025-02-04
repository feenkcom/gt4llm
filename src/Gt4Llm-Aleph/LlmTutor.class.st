Class {
	#name : #LlmTutor,
	#superclass : #Object,
	#instVars : [
		'providerStencil',
		'format'
	],
	#category : #'Gt4Llm-Aleph'
}

{ #category : #'as yet unclassified' }
LlmTutor >> actionNamed: anActionName [
	^ self format actionNamed: anActionName
]

{ #category : #accessing }
LlmTutor >> actions [
	^ actions
]

{ #category : #accessing }
LlmTutor >> actions: anObject [
	actions := anObject
]

{ #category : #'as yet unclassified' }
LlmTutor >> addAction: anAction [
	format addAction: (anAction tutor: self)
]

{ #category : #'as yet unclassified' }
LlmTutor >> addFormatComponent: aComponent [
	format addComponent: aComponent
]

{ #category : #'as yet unclassified' }
LlmTutor >> collectFormatComponents [
	^ ((Pragma
		allNamed: #gtLlmFormatComponent
		from: self class
		to: Object)
		collect: [ :aPragma | (self perform: aPragma methodSelector) tutor: self ])
		sorted: [ :a :b | a priority < b priority ]
]

{ #category : #'as yet unclassified' }
LlmTutor >> createChat [
	^ GtLlmChat new
		provider: (self providerStencil value: self format) beActionBased;
		tutor: self
]

{ #category : #accessing }
LlmTutor >> format [
	^ format
]

{ #category : #accessing }
LlmTutor >> format: anObject [
	format := anObject
]

{ #category : #'as yet unclassified' }
LlmTutor >> formatComponentNamed: aString [
	^ self format componentNamed: aString
]

{ #category : #'as yet unclassified' }
LlmTutor >> formatComponents [
	^ self format formatComponents
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ self format ];
		view: #gtActionsFor:
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtFormatComponentsFor: aView [
	<gtView>
	^ aView forward
		title: 'Format components';
		priority: 11;
		object: [ self format ];
		view: #gtComponentsFor:
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 10;
		object: [ self format asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #views }
LlmTutor >> gtInstructionsFor: aView [
	<gtView>
	instructions ifNil: [ ^ aView empty ].
	^ aView textEditor
		priority: 1;
		title: 'Instructions';
		text: [ self instructions ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new threadMessage: GtLlmNewThreadMessage new));
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save'
			action: [ :aButton :aTab | 
				| tabGroup |
				tabGroup := aTab
						withAllParentsDetect: [ :aParent | aParent isKindOf: BrTabGroup ]
						ifFound: #yourself
						ifNone: [ nil ].
				tabGroup
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | self instructions: anEditor text asString ] ]
]

{ #category : #'as yet unclassified' }
LlmTutor >> initialize [
	super initialize.
	
	format := LlmTutorFormat new addComponents: self collectFormatComponents
]

{ #category : #accessing }
LlmTutor >> instructions [
	^ self format instructions
]

{ #category : #accessing }
LlmTutor >> instructions: anObject [
	self format instructions: anObject
]

{ #category : #'as yet unclassified' }
LlmTutor >> providerFormat [
	^ format actions: actions
]

{ #category : #accessing }
LlmTutor >> providerStencil [
	^ providerStencil
]

{ #category : #accessing }
LlmTutor >> providerStencil: anObject [
	providerStencil := anObject
]

{ #category : #'as yet unclassified' }
LlmTutor >> textFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted, but code blocks with three tick marks MAY NOT be used.

# Headings exist as well
```'
]
