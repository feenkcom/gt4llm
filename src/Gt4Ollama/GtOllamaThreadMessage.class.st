Class {
	#name : #GtOllamaThreadMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'content',
		'promptEvalDuration',
		'model',
		'createdAt',
		'evalDuration',
		'totalDuration',
		'loadDuration',
		'doneReason',
		'promptEvalCount',
		'evalCount'
	],
	#category : #'Gt4Ollama-Models'
}

{ #category : #accessing }
GtOllamaThreadMessage class >> from: anArray [
	^ self new
		from: anArray last;
		rawData: anArray;
		content: ('' join: (anArray collect: [ :aDict | aDict at: #message at: #content ]))
]

{ #category : #accessing }
GtOllamaThreadMessage class >> serializationProperties [
	^ {
		#content -> #content.
		#role -> #role.
		#eval_count -> #evalCount.
		#prompt_eval_duration->#promptEvalDuration.
		#model -> #model.
		#created_at -> #createdAt.
		#eval_duration -> #evalDuration.
		#total_duration -> #totalDuration.
		#load_duration -> #loadDuration.
		#done_reason -> #doneReason.
		#prompt_eval_count -> #promptEvalCount
	}
]

{ #category : #accessing }
GtOllamaThreadMessage >> content [
	^ content
]

{ #category : #accessing }
GtOllamaThreadMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOllamaThreadMessage >> createdAt: anObject [
	createdAt := DateAndTime fromString: anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> doneReason [
	^ doneReason
]

{ #category : #accessing }
GtOllamaThreadMessage >> doneReason: anObject [
	doneReason := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalCount [
	^ evalCount
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalCount: anObject [
	evalCount := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalDuration [
	^ evalDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> evalDuration: anObject [
	evalDuration := anObject nanoSeconds
]

{ #category : #accessing }
GtOllamaThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ];
		styler: (GtLlmMessageStyler new
				threadMessageViewModel: (GtLlmNewThreadMessageViewModel new
						threadMessage: GtLlmNewThreadMessage new))
]

{ #category : #accessing }
GtOllamaThreadMessage >> loadDuration [
	^ loadDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> loadDuration: anObject [
	loadDuration := anObject nanoSeconds
]

{ #category : #accessing }
GtOllamaThreadMessage >> model [
	^ model
]

{ #category : #accessing }
GtOllamaThreadMessage >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalCount [
	^ promptEvalCount
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalCount: anObject [
	promptEvalCount := anObject
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalDuration [
	^ promptEvalDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> promptEvalDuration: anObject [
	promptEvalDuration := anObject nanoSeconds
]

{ #category : #accessing }
GtOllamaThreadMessage >> role [
	^ 'assistant'
]

{ #category : #'as yet unclassified' }
GtOllamaThreadMessage >> role: anArgument [
	"we ignore the role"
]

{ #category : #accessing }
GtOllamaThreadMessage >> totalDuration [
	^ totalDuration
]

{ #category : #accessing }
GtOllamaThreadMessage >> totalDuration: anObject [
	totalDuration := anObject nanoSeconds
]
