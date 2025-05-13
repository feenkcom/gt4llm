Class {
	#name : #GtOpenAIMessage,
	#superclass : #GtLlmChatMessage,
	#instVars : [
		'threadId',
		'assistantId',
		'runId',
		'metadata',
		'annotations',
		'pipeline',
		'step',
		'completedAt',
		'incompleteAt'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIMessage class >> from: aDict [
	^ self new from: aDict
]

{ #category : #accessing }
GtOpenAIMessage class >> serializationProperties [
	^ {
		#assistant_id -> #assistantId.
		#content -> #content.
		#created_at -> #createdAtString.
		#incomplete_at -> #incompleteAtString.
		#completed_at -> #completedAtString.
		#id -> #idString.
		#metadata -> #metadata.
		#run_id -> #runId.
		#thread_id -> #threadId.
		#role -> #role.
		#attachments -> #attachments
	}
]

{ #category : #accessing }
GtOpenAIMessage >> ancestor [
	^ self chat ancestorOf: self
]

{ #category : #accessing }
GtOpenAIMessage >> annotations [
	(content isKindOf: String) ifTrue: [ ^ GtOpenAIAnnotationsGroup new ].

	^ annotations
		ifNil: [ annotations := GtOpenAIAnnotationsGroup
					withAll: ((content select: [ :aValue | (aValue at: 'type') = 'text' ])
							flatCollect: [ :aValue | 
								((aValue at: 'text') at: 'annotations')
									collect: [ :anAnnotation | 
										(GtOpenAIAnnotation from: anAnnotation)
											client: self client;
											message: self ] ]) ]
]

{ #category : #accessing }
GtOpenAIMessage >> assistantId [
	^ assistantId
]

{ #category : #accessing }
GtOpenAIMessage >> assistantId: anObject [
	assistantId := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
GtOpenAIMessage >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> completedAt [
	^ completedAt
]

{ #category : #accessing }
GtOpenAIMessage >> completedAt: anObject [
	completedAt := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> completedAtString [
	^ nil
]

{ #category : #accessing }
GtOpenAIMessage >> completedAtString: anObject [
	completedAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIMessage >> content [
	^ content
]

{ #category : #accessing }
GtOpenAIMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtOpenAIMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtOpenAIMessage >> contentText [
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
GtOpenAIMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> createdAtString [
	^ nil
]

{ #category : #accessing }
GtOpenAIMessage >> createdAtString: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtOpenAIMessage >> elementClass [
	^ self explicitRequirement
]

{ #category : #accessing }
GtOpenAIMessage >> gtAnnotationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 2;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
]

{ #category : #testing }
GtOpenAIMessage >> hasResponse [
	^ self contentText isNotEmpty
]

{ #category : #accessing }
GtOpenAIMessage >> hasStep [
	^ self step isNotNil
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> idString [
	^ nil
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> idString: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> incompleteAt [
	^ incompleteAt
]

{ #category : #accessing }
GtOpenAIMessage >> incompleteAt: anObject [
	incompleteAt := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> incompleteAtString [
	^ nil
]

{ #category : #accessing }
GtOpenAIMessage >> incompleteAtString: anObject [
	incompleteAt := self deserializeTime: anObject
]

{ #category : #testing }
GtOpenAIMessage >> isAssistantRole [
	^ self role = #assistant
]

{ #category : #testing }
GtOpenAIMessage >> isFailure [
	^ false
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> isReady [
	^ self incompleteAt isNil or: [ self completedAt ]
]

{ #category : #testing }
GtOpenAIMessage >> isSystemRole [
	^ self role = #system
]

{ #category : #testing }
GtOpenAIMessage >> isUserRole [
	^ self role = #user
]

{ #category : #'as yet unclassified' }
GtOpenAIMessage >> messageFiles [
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
GtOpenAIMessage >> metadata [
	^ metadata
]

{ #category : #accessing }
GtOpenAIMessage >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> role [
	^ role
]

{ #category : #accessing }
GtOpenAIMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> runId [
	^ runId
]

{ #category : #accessing }
GtOpenAIMessage >> runId: anObject [
	runId := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> senderText [
	self isAssistantRole ifTrue: [ ^ 'Assistant' ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	^ 'You'
]

{ #category : #accessing }
GtOpenAIMessage >> step [
	^ step
]

{ #category : #accessing }
GtOpenAIMessage >> step: anObject [
	step := anObject
]

{ #category : #accessing }
GtOpenAIMessage >> styler [
	^ self explicitRequirement
]

{ #category : #accessing }
GtOpenAIMessage >> threadId [
	^ threadId
]

{ #category : #accessing }
GtOpenAIMessage >> threadId: anObject [
	threadId := anObject
]
