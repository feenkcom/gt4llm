Class {
	#name : #GtLWorldScreenshotDataDomainObject,
	#superclass : #GtLDomainObject,
	#instVars : [
		'encodedBytes'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #private }
GtLWorldScreenshotDataDomainObject >> bytes: aByteArray [ 
	encodedBytes := aByteArray
]

{ #category : #accessing }
GtLWorldScreenshotDataDomainObject >> encodedBytes [
	^ encodedBytes base64Encoded
]

{ #category : #views }
GtLWorldScreenshotDataDomainObject >> gtImageFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Image';
		priority: 1;
		object: [ self skiaImage ];
		view: #gtPreviewFor:
]

{ #category : #serialization }
GtLWorldScreenshotDataDomainObject >> serializeToOpenAIResponseJsonObject [
	<return: #String>
	^ "'data:image/jpeg;base64', self encodedBytes" super serializeToOpenAIResponseJsonObject
]

{ #category : #serialization }
GtLWorldScreenshotDataDomainObject >> serializeToOpenAIResponseOutput [
		"Return a JSON that represents tool response output.
	See GtLToolMessage>>#serializeForOpenAIResponsesAPI for more information."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			"at: #text put: self serializeToOpenAIResponseJsonString"
			at: #image_url put: ('data:image/png;base64,' , self encodedBytes);
			at: #type put: #input_image;
			yourself}
]

{ #category : #accessing }
GtLWorldScreenshotDataDomainObject >> skiaImage [
	^ SkiaImage
		fromBuffer: encodedBytes
		start: 0
		end: encodedBytes size - 1
]
