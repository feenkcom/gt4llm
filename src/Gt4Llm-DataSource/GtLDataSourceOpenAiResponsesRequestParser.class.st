Class {
	#name : #GtLDataSourceOpenAiResponsesRequestParser,
	#superclass : #GtLDataSourceRequestParser,
	#category : #'Gt4Llm-DataSource-Parser'
}

{ #category : #api }
GtLDataSourceOpenAiResponsesRequestParser >> parseRequest: requestResponse for: aMessageConstructor [

	| jsonRequest request messagesEntity role message chat |

	chat := aMessageConstructor chat.
	jsonRequest := requestResponse request asGtJson jsonObject.
	request := GtLOpenAiResponsesRequestEntity rawData: jsonRequest.
	chat provider model ifNil:
		[ chat provider modelName: request model ].
	messagesEntity := request input last.
	messagesEntity hasRole ifTrue:
	[ role := messagesEntity role.
	role = 'user' ifTrue:
		[ message := self parseUserRequest: requestResponse messagesEntity: messagesEntity for: aMessageConstructor ].
	role = 'tool' ifTrue: [ ^ nil ].
	message ifNil:
		[ self error: 'Unknown role: ', role asString ].

	request tools ifNotNil: [ :toolsEntity |
		aMessageConstructor addToolsFrom: toolsEntity to: message ].
].
	^ message
]

{ #category : #private }
GtLDataSourceOpenAiResponsesRequestParser >> parseUserRequest: requestResponse messagesEntity: messagesEntity for: aMessageConstructor [
	| contentEntity type message chat |
	
	chat := aMessageConstructor chat.
	contentEntity := messagesEntity content first.
	type := contentEntity type.
	type = 'input_text' ifFalse: [ self error: 'Unknown type: ', type asString ].
	message := chat provider userMessageClass new 
			addInputModel: contentEntity textModel;
			requestResponse: requestResponse.
	chat addUserMessage: message.
	^ message
]
