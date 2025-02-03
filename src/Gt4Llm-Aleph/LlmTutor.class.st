Class {
	#name : #LlmTutor,
	#superclass : #Object,
	#instVars : [
		'instructions',
		'providerStencil',
		'actions'
	],
	#category : #'Gt4Llm-Aleph'
}

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
	actions add: (anAction tutor: self)
]

{ #category : #'as yet unclassified' }
LlmTutor >> createChat [
	^ GtLlmChat new provider: (self providerStencil value: self createProviderInstructions)
]

{ #category : #'as yet unclassified' }
LlmTutor >> createProviderInstructions [
	^ self instructions
		, '

'
		, (GtLlmInstructionSection new
				title: 'Actions';
				body: (GtLlmInstructionWithSections new
						introduction: 'All actions are listed below.';
						sections: (actions collect: #asInstruction))) instructionString
]

{ #category : #'as yet unclassified' }
LlmTutor >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ actions ];
		view: #gtActionsFor:
]

{ #category : #views }
LlmTutor >> gtInstructionsFor: aView [
	<gtView>
	instructions ifNil: [ ^ aView empty ].
	^ aView textEditor
		priority: 1;
		title: 'Instructions';
		text: [ instructions ];
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

	actions := GtLlmActionsGroup new
]

{ #category : #accessing }
LlmTutor >> instructions [
	^ instructions
]

{ #category : #accessing }
LlmTutor >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
LlmTutor >> providerStencil [
	^ providerStencil
]

{ #category : #accessing }
LlmTutor >> providerStencil: anObject [
	providerStencil := anObject
]
