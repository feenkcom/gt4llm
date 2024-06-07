Class {
	#name : #GtLlmTutorStep,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'rules',
		'pipeline',
		'chat',
		'elementClass'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorStep >> actions [
	^ {}
]

{ #category : #accessing }
GtLlmTutorStep >> asInstruction [
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmCompositeInstruction new
				addItem: self description;
				addItem: (GtLlmInstructionList new items: self rules))
]

{ #category : #accessing }
GtLlmTutorStep >> buildActionButtonLabelled: aString withAction: aBlock [
	^ BrButton new
		fitContent;
		beSmallSize;
		aptitude: BrGlamorousButtonWithLabelAptitude;
		label: aString;
		action: aBlock;
		margin: (BlInsets all: 3);
		constraintsDo: [ :c | 
			c linear vertical alignBottom.
			c linear horizontal alignLeft ]
]

{ #category : #accessing }
GtLlmTutorStep >> buildNextStepButton [
	^ self
		buildActionButtonLabelled: 'Next Step'
		withAction: [ :aButton | 
			self chat sendMessage: self chat stepMessage.
			aButton phlow fireToolUpdateWish ]
]

{ #category : #accessing }
GtLlmTutorStep >> buildPreviousStepButton [
	^ self
		buildActionButtonLabelled: 'Previous Step'
		withAction: [ :aButton | 
			self chat sendMessage: self chat backStepMessage.
			aButton phlow fireToolUpdateWish ]
]

{ #category : #accessing }
GtLlmTutorStep >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmTutorStep >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> defaultElementClass [
	^ GtLlmExpandableStepThreadMessageElement
]

{ #category : #accessing }
GtLlmTutorStep >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorStep >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> elementClass [
	^ elementClass
]

{ #category : #accessing }
GtLlmTutorStep >> elementClass: anObject [
	elementClass := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> gtInstructionsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Instructions';
		priority: 3;
		text: [ self asInstruction instructionString ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new
						threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtLlmTutorStep >> gtPipelineFor: aView [
	<gtView>
	^ aView forward
		title: 'Pipeline';
		priority: 2;
		object: [self pipeline];
		view: #gtCompositionFor:
]

{ #category : #accessing }
GtLlmTutorStep >> gtSummary [
	^ {'Name' -> self name.
		'Description' -> self description.
		'Rules' -> self rules}
]

{ #category : #accessing }
GtLlmTutorStep >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 1;
		items: [ self gtSummary ];
		column: 'Property'
			text: #key
			width: 120;
		column: 'Value' text: #value;
		send: #value;
		actionUpdateButton
]

{ #category : #accessing }
GtLlmTutorStep >> initialize [
	super initialize.
	
	elementClass := self defaultElementClass
]

{ #category : #accessing }
GtLlmTutorStep >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorStep >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmTutorStep >> pipeline: anObject [
	pipeline := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> rules [
	^ rules
]

{ #category : #accessing }
GtLlmTutorStep >> rules: anObject [
	rules := anObject
]
