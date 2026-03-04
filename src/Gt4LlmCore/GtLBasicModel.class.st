Class {
	#name : #GtLBasicModel,
	#superclass : #Object,
	#category : #Gt4LlmCore
}

{ #category : #serialization }
GtLBasicModel >> serializeToAnthropicResponseOutput [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: 'text' put: self serializeToLlmJsonString;
			at: 'type' put: 'text';
			yourself}
]

{ #category : #serialization }
GtLBasicModel >> serializeToLlmJsonObject [
	self subclassResponsibility
]

{ #category : #serialization }
GtLBasicModel >> serializeToLlmJsonString [
	"Return a JSON string that represents the domain object."
	
	^ NeoJSONWriter toStringPretty: self serializeToLlmJsonObject
]

{ #category : #serialization }
GtLBasicModel >> serializeToOpenAIResponseOutput [
	"Return a JSON that represents tool response output."

	<return: #Array of: #NeoJSONObject>
	^ {NeoJSONObject new
			at: #text put: self serializeToLlmJsonString;
			at: #type put: #input_text;
			yourself}
]
