Class {
	#name : #GtLOpenAIRawCompactionData,
	#superclass : #GtLEntity,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIRawCompactionData >> contentText [
	^ self encryptedContent
]

{ #category : #accessing }
GtLOpenAIRawCompactionData >> encryptedContent [
	^ rawData at: 'encrypted_content'
]

{ #category : #printing }
GtLOpenAIRawCompactionData >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	
	aStream parenthesize: [
		aStream nextPutAll: self contentText ]
]

{ #category : #views }
GtLOpenAIRawCompactionData >> gtViewContentFor: aView [
	<gtView>
	^(aView forward)
		title: 'Content';
		object: [self encryptedContent];
		view: #gtStringFor:
]

{ #category : #serialization }
GtLOpenAIRawCompactionData >> serializeForOpenAIResponsesAPIFromMessage: aMessage [
	^ {
		'encrypted_content' ->self encryptedContent.
		'type' -> 'compaction'
	} asDictionary
]
