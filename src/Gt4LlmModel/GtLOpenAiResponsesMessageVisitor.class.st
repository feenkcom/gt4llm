Class {
	#name : #GtLOpenAiResponsesMessageVisitor,
	#superclass : #Object,
	#category : #'Gt4LlmModel-Visitors'
}

{ #category : #api }
GtLOpenAiResponsesMessageVisitor >> chatMessage: aMessage [

	^ self visitNode: aMessage.
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> compactionOutputFrom: anAssistantMessage [
	| output |
	
	output := anAssistantMessage requestResponse result at: 'output'.
	^ output reversed detect: [ :jsonObject |
		(jsonObject at: 'type') = 'compaction' ]
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> roleAndContentFrom: anAssistantMessage [
	| content |

	content := { {
		'type' -> 'output_text'.
		'text' -> anAssistantMessage contentText 
		} asDictionary.
		}.
	^ {
		'role' -> anAssistantMessage role.
		'content' -> content.
		} asDictionary.
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLModelAssistantMessage: anAssistantMessage [
	"If the message includes a compaction output, only supply that output"
	| provider |
	
	provider := anAssistantMessage chat provider.
	
	^ (provider assistantMessageHasCompactionResponse: anAssistantMessage) ifTrue:
		[ self compactionOutputFrom: anAssistantMessage ]
	ifFalse:
		[ self roleAndContentFrom: anAssistantMessage ].
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLModelUserMessage: aUserMessage [
	| content |
	
	content := aUserMessage contentDataBlock  acceptVisitor: self.
	^ {
		'role' -> aUserMessage role.
		'content' -> content.
		} asDictionary.
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveCompositeJsonGenericDataBlock: aDataBlock [
	| content |

	content := aDataBlock jsonDataBlocks 
			collect: [ :dataBlock |
				dataBlock acceptVisitor: self ]
			as: Array.

	^ aDataBlock dataKey ifNil:
		[ content ]
	ifNotNil:
		[ { aDataBlock dataKey -> content } asDictionary ]
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveJsonBareDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData.
	self assert: string isString.
	^ string
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveJsonDataBlock: aDataBlock [
	"This is a bit of a hack at the moment.
	If the data block is just content, assume that the message is a simple string and just answer the content, otherwise answer the string serialisation."

	^ aDataBlock jsonData 
		at: 'content'
		ifPresent: [ :string |
			self assert: string isString.
			string ]
		ifAbsent:
			[ NeoJSONWriter toStringPretty: aDataBlock jsonData ].
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [
	| content |

	content := aDataBlock dataBlocks collect:
		[ :each |
			NeoJSONObject new
				at: 'text' put: each serializedJsonString;
				at: 'type' put: 'input_text';
				yourself ]
		as: OrderedCollection.

	aDataBlock imageDataBlocks do: [ :dataBlock |
		content add: {
			'type' -> 'image_url'.
			'image_url' -> ('data:image/', dataBlock imageType, ';base64,', dataBlock encodedBytes).
			} asDictionary. ].
	^ content asArray.
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitNode: aUserMessage [

	^ aUserMessage acceptVisitor: self
]
