Class {
	#name : #GtLOpenAIRawMessageData,
	#superclass : #GtLEntity,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIRawMessageData >> contentText [
	^ '' join: (self rawContent collect: [:each | 
		each at: 'text' ])
]

{ #category : #printing }
GtLOpenAIRawMessageData >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	
	aStream parenthesize: [
		aStream nextPutAll: self contentText ]
]

{ #category : #'gt - extensions' }
GtLOpenAIRawMessageData >> gtViewContentFor: aView [
	<gtView>
	^(aView forward)
		title: 'Content';
		object: [self contentText];
		view: #gtStringFor:
]

{ #category : #accessing }
GtLOpenAIRawMessageData >> rawContent [
	^ rawData at: 'content'
]

{ #category : #serialization }
GtLOpenAIRawMessageData >> serializeForOpenAIResponsesAPIFromMessage: aMessage [
	^ {
		'content' -> {{
				'type' -> 'output_text'.
				'text' -> self contentText} asDictionary}.
		'role' -> aMessage role
	} asDictionary
]
