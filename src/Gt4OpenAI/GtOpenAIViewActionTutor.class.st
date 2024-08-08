Class {
	#name : #GtOpenAIViewActionTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIViewActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIViewActionAssistantChat new
			assistant: self assistant;
			actions: actions;
			tutor: self;
			responseFormat: self format asJsonSchema;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> formatName [
	^ 'Glamorous Toolkit Phlow views'
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> generateViewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Generate a Phlow view';
		priority: 4;
		description: 'Proposes a sensible Phlow view to the object provided. It should be as minimal as possible, yet still be useful. The view MUST respect the context of the object, and MUST NOT exist yet on the object. The view MUST be of type `textEditor`, `list`, `columnedList`, `tree`, or `columnedTree`.';
		format: 'Generate a Phlow view';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Generate a Phlow view'.
							'Object'
								-> (GtLlmInspectorSummarizer new
										summarizeWithoutMarkup: (Bag
												withAll: {1.
														2.
														3})) summaryString} asDictionary;
					output: {'Action' -> 'Generate a Phlow view'.
							'Object'
								-> (GtLlmInspectorSummarizer new
										summarizeWithoutMarkup: (Bag
												withAll: {1.
														2.
														3})) summaryString.
							'Smalltalk method'
								-> 'Bag
gtUniqueItemsFor: aView
	<gtView>
	^ aView columnedList
		title: ''Unique items'' translated;
		priority: 100;
		items: [ self asSet ];
		column: ''Item'' text: [ :eachItem | eachItem gtDisplayText ];
		actionUpdateButtonTooltip: ''Update item list'''} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Generate a Phlow view'.
							'Object'
								-> (GtLlmInspectorSummarizer new
										summarizeWithoutMarkup: (GtABAddress new
												city: 'Boston';
												country: 'USA')) summaryString} asDictionary;
					output: {'Action' -> 'Generate a Phlow view'.
							'Object'
								-> (GtLlmInspectorSummarizer new
										summarizeWithoutMarkup: (GtABAddress new
												city: 'Boston';
												country: 'USA')) summaryString.
							'Smalltalk method'
								-> 'GtABAddress
gtAddressStringFor: aView
	<gtView>
	^ aView textEditor
		title: ''Address string'' translated;
		priority: 100;
		text: [ self asString ]
'} asDictionary}
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> initialize [
	super initialize.

	self initializePipeline
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> initializePipeline [
	self
		pipelineBuilder: [ GtLlmContext new
				instance: GtLlmObjectHolder new;
				isImmutableInstance: true ]
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> methodFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Smalltalk method';
		priority: 2;
		format: 'Smalltalk language';
		example: '```
AClass
aMethodWithArguments: anArgument and: anotherArgument
	^ anArgument + anotherArgument
```'
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> objectFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Smalltalk object';
		priority: 2;
		format: 'Text';
		example: '```
'
				, (GtLlmInspectorSummarizer new summarizeWithoutMarkup: Color blue) summaryString
				, '
```'
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> textFormatComponent [
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
