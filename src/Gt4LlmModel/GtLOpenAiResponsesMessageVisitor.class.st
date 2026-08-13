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
	"Assistant messages always serialize as ordinary assistant content.
	Server-side compaction is represented by a separate message."

	^ self roleAndContentFrom: anAssistantMessage
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesMessageVisitor >> visitGtLModelCompactionMessage: aCompactionMessage [
	"Automatic OpenAI compaction output is already in the representation
	expected by the Responses API. Explicit prompt-compaction responses still
	serialize as ordinary assistant content."

	aCompactionMessage isServerSideCompactionOutput
		ifTrue: [ ^ aCompactionMessage rawData ].

	^ self roleAndContentFrom: aCompactionMessage
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

	^ aDataBlock condensedJsonBlock acceptVisitor: self.
	"content := aDataBlock jsonDataBlocks 
			collect: [ :dataBlock |
				dataBlock acceptVisitor: self ]
			as: Array.

	^ aDataBlock dataKey ifNil:
		[ content ]
	ifNotNil:
		[ { aDataBlock dataKey -> content } asDictionary ]"
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveImageDataBlock: aDataBlock [

	^ {NeoJSONObject new
			at: 'image_url' put: ('data:image/'
				, aDataBlock imageType,';base64,' , aDataBlock encodedBytes);
			at: 'type' put: 'input_image';
			yourself}
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveJsonBareDataBlock: aDataBlock [
	| string |

	string := aDataBlock jsonData.
	self assert: string isString.
	^ {NeoJSONObject new
			at: #text put: string;
			at: #type put: #input_text;
			yourself}
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveJsonDataBlock: aDataBlock [

	^ {NeoJSONObject new
			at: #text put: aDataBlock serializedJsonString;
			at: #type put: #input_text;
			yourself}
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitGtLPrimitiveMessageDataBlock: aDataBlock [
	| content |

	content := OrderedCollection new.
	aDataBlock dataBlocks do: [ :aDataBlockBlock |
		content addAll: (aDataBlockBlock acceptVisitor: self) ].
		
		
		

	"content := aDataBlock dataBlocks collect:
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
			} asDictionary. ]."
	^ content asArray.
]

{ #category : #visiting }
GtLOpenAiResponsesMessageVisitor >> visitNode: aUserMessage [

	^ aUserMessage acceptVisitor: self
]
