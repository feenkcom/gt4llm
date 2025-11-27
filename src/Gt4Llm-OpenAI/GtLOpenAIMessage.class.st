Class {
	#name : #GtLOpenAIMessage,
	#superclass : #GtLChatMessage,
	#instVars : [
		'threadId',
		'runId',
		'metadata',
		'step',
		'completedAt',
		'incompleteAt'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIMessage class >> defaultRole [
	^ nil
]

{ #category : #'instance creation' }
GtLOpenAIMessage class >> from: aDict [
	^ self new from: aDict
]

{ #category : #accessing }
GtLOpenAIMessage class >> leJsonV4Name [

	^ #gtLOpenAIMessage
]

{ #category : #accessing }
GtLOpenAIMessage class >> serializationProperties [
	^ {
		#content -> #content.
		#created_at -> #createdAtString.
		#incomplete_at -> #incompleteAtString.
		#completed_at -> #completedAtString.
		#id -> #idString.
		#metadata -> #metadata.
		#run_id -> #runId.
		#thread_id -> #threadId.
		#role -> #role
	}
]

{ #category : #accessing }
GtLOpenAIMessage >> annotations [
	(content isKindOf: String) ifTrue: [ ^ GtOpenAIAnnotationsGroup new ].

	^ GtOpenAIAnnotationsGroup
		withAll: ((content select: [ :aValue | (aValue at: 'type') = 'text' ])
				flatCollect: [ :aValue | 
					((aValue at: 'text') at: 'annotations')
						collect: [ :anAnnotation | 
							(GtOpenAIAnnotation from: anAnnotation)
								client: self client;
								message: self ] ])
]

{ #category : #accessing }
GtLOpenAIMessage >> completedAt [
	^ completedAt
]

{ #category : #accessing }
GtLOpenAIMessage >> completedAt: anObject [
	completedAt := anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> completedAtString [
	^ nil
]

{ #category : #accessing }
GtLOpenAIMessage >> completedAtString: anObject [
	completedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> content [
	^ content
]

{ #category : #accessing }
GtLOpenAIMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtLOpenAIMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLOpenAIMessage >> contentText [
	^ (content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						collect: [ :aValue | 
							(aValue at: 'text' ifAbsent: [ nil ])
								ifNil: [ '' ]
								ifNotNil: [ :aTextObject | 
									(aTextObject isKindOf: String)
										ifTrue: [ aTextObject ]
										ifFalse: [ (aTextObject at: 'value') ifNil: [ '' ] ] ] ]) ]
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAtString [
	^ nil
]

{ #category : #accessing }
GtLOpenAIMessage >> createdAtString: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> elementClass [
	^ self explicitRequirement
]

{ #category : #accessing }
GtLOpenAIMessage >> gtAnnotationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 20;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
]

{ #category : #testing }
GtLOpenAIMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #accessing }
GtLOpenAIMessage >> hasStep [
	^ self step isNotNil
]

{ #category : #accessing }
GtLOpenAIMessage >> idString [
	^ nil
]

{ #category : #accessing }
GtLOpenAIMessage >> idString: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> incompleteAt [
	^ incompleteAt
]

{ #category : #accessing }
GtLOpenAIMessage >> incompleteAtString [
	^ nil
]

{ #category : #accessing }
GtLOpenAIMessage >> isReady [
	^ incompleteAt isNil or: [ completedAt notNil ]
]

{ #category : #accessing }
GtLOpenAIMessage >> messageFiles [
	self contentText = self content ifTrue: [ ^ GtOpenAIFilesGroup new ].

	^ self content
		select: [ :aValue | (aValue at: 'type') = 'input_image' ]
		thenCollect: [ :aValue | 
			| byteArray |
			byteArray := ((aValue at: 'image_url')
					removePrefix: 'data:image/jpeg;base64,') base64Decoded.
			SkiaImage
				fromBuffer: byteArray
				start: 0
				end: byteArray size - 1 ]
]

{ #category : #accessing }
GtLOpenAIMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
GtLOpenAIMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> runId [
	^ runId
]

{ #category : #accessing }
GtLOpenAIMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> step [
	^ step
]

{ #category : #accessing }
GtLOpenAIMessage >> step: anObject [
	step := anObject
]

{ #category : #accessing }
GtLOpenAIMessage >> styler [
	^ self explicitRequirement
]

{ #category : #accessing }
GtLOpenAIMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
GtLOpenAIMessage >> threadId: anObject [
	threadId := anObject
]
