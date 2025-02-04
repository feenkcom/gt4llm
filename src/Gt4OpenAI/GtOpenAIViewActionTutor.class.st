Class {
	#name : #GtOpenAIViewActionTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAIViewActionTutor >> chatClass [
	^ GtOpenAIViewActionAssistantChat
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> formatName [
	^ 'Glamorous Toolkit Phlow views'
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> generateListViewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Generate a Phlow list view';
		priority: 4;
		description: 'Proposes a sensible Phlow list view for the object provided and the slot that was given by the users. It should be as minimal as possible, yet still be useful. The view MUST respect the context of the object, and MUST NOT exist yet on the object. The view MUST be of type `list`.';
		format: 'Generate a Phlow list view for the slot `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Generate a Phlow list view'.
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
							'Text' -> nil.
							'Smalltalk method'
								-> 'Bag
gtUniqueItemsFor: aView
	<gtView>
	^ aView list
		title: ''Unique items'' translated;
		priority: 100;
		items: [ self asSet ];
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
										summarizeWithoutMarkup: (GtABContact new
												firstName: 'John';
												lastName: 'Doe';
												addTelephone: (GtABTelephone new
														prefix: '+1202';
														number: '5550112'))) summaryString.
							'Text' -> nil.
							'Smalltalk method'
								-> 'GtABContact
gtTelephonesFor: aView
	<gtView>
	^ aView list
		title: ''Telephones'';
		priority: 100;
		items: [ self telephones ]
'} asDictionary}
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> generateViewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Generate a Phlow view';
		priority: 4;
		description: 'Proposes a sensible Phlow view to the object provided. It should be as minimal as possible, yet still be useful. The view MUST respect the context of the object, and MUST NOT exist yet on the object. The view MUST be of type `textEditor`, `list`, `columnedList`, `tree`, or `columnedTree`.';
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
							'Text' -> nil.
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
							'Text' -> nil.
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

{ #category : #'as yet unclassified' }
GtOpenAIViewActionTutor >> messageClass [
	^ GtOpenAIViewActionThreadMessage
]

{ #category : #accessing }
GtOpenAIViewActionTutor >> methodFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatDescription new
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
	^ GtLlmTutorFormatDescription new
		name: 'Object';
		priority: 2;
		format: 'Text';
		example: '```
'
				, (GtLlmInspectorSummarizer new summarizeWithoutMarkup: Color blue) summaryString
				, '
```'
]
