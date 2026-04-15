Class {
	#name : #GtLTextFile,
	#superclass : #GtLFileReference,
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #serialization }
GtLTextFile >> contentType [
		^ 'text/plain'
]

{ #category : #views }
GtLTextFile >> llmDocumentDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView documentData
		document: [ self fileReference binaryContents ];
		contentType: self contentType
]

{ #category : #serialization }
GtLTextFile >> serializeToAnthropicResponseOutput [
	^ {
		'type' -> 'document'.
		'source'-> {
			'media_type' -> self contentType.
			'type' ->'base64'.
			'data' -> self base64EncodedContent } asDictionary}
			asDictionary
]

{ #category : #serialization }
GtLTextFile >> serializeToOpenAIResponseOutput [
	^ {'type' -> 'input_file'.
		'filename' -> self fileReference basename.
		'file_data' -> ('data:'
				, self contentType 
				,';base64,' 
				, self base64EncodedContent)}
			asDictionary
]
