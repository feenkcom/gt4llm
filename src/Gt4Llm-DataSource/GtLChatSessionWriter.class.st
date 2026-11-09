"
I write the request / response history of a {{gtClass:GtLChat}} to a file as the session progresses.

When attached to an idle chat, I immediately write its existing history. When attached to a non-idle chat, I wait until it becomes idle. I subscribe to {{gtClass:GtLChatExecutionStateChanged}} announcements and append only unwritten request / responses using {{gtClass:GtLDataSourceEncoderDecoder}}. An empty history does not create a file.

Create with `GtLChatSessionWriter forChat: aChat` or `GtLChatSessionWriter forChat: aChat file: aFileReference`.

Default filenames have the form `YYYY-MM-DD_hhmmss_uid_chat.jsonl`, with the uid of the chat's first message after the timestamp. Empty chats use a fresh UUID suffix. The file reference is cached on first access.
"
Class {
	#name : #GtLChatSessionWriter,
	#superclass : #Object,
	#instVars : [
		'chat',
		'file',
		'encoder',
		'lastRequestResponse',
		'mutex',
		'recoveryFailure'
	],
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #'instance creation' }
GtLChatSessionWriter class >> defaultFileReference [
	"Answer a timestamped file reference with a unique suffix when no chat is supplied."

	^ self defaultFileReferenceForUid: nil
]

{ #category : #'instance creation' }
GtLChatSessionWriter class >> defaultFileReferenceForUid: aUid [
	"Include the chat identity after the timestamp. Empty chats need a unique fallback."

	| now suffix |
	now := DateAndTime now.
	suffix := aUid ifNil: [ UUID new asString ].
	^ (String
		streamContents: [ :stream | 
			stream
				<< now asDate iso8601;
				<< '_';
				<< now asTime hhmmss24;
				<< '_';
				<< suffix asString;
				<< '_chat.jsonl' ]) asFileReference
]

{ #category : #'instance creation' }
GtLChatSessionWriter class >> forChat: aGtLChat [
	^ self new chat: aGtLChat
]

{ #category : #'instance creation' }
GtLChatSessionWriter class >> forChat: aGtLChat file: aFileReference [
	^ self new
		file: aFileReference;
		chat: aGtLChat
]

{ #category : #private }
GtLChatSessionWriter >> appendBytes: bytes on: stream [
	stream nextPutAll: bytes
]

{ #category : #accessing }
GtLChatSessionWriter >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatSessionWriter >> chat: aGtLChat [
	chat ifNotNil: [ self unsubscribe ].
	chat := aGtLChat.
	lastRequestResponse := nil.
	self subscribe.
	chat state
		ifCanStop: [  ]
		ifStopping: [  ]
		ifIdle: [ self writeLatest ]
]

{ #category : #accessing }
GtLChatSessionWriter >> file [
	^ file ifNil: [ file := self class defaultFileReferenceForUid: self chat uid ]
]

{ #category : #accessing }
GtLChatSessionWriter >> file: aFileReference [
	file := aFileReference asFileReference
]

{ #category : #private }
GtLChatSessionWriter >> flushStream: stream [
	stream flush
]

{ #category : #accessing }
GtLChatSessionWriter >> history [
	<return: #GtLRequestHistory>
	^ chat provider client history
]

{ #category : #initialization }
GtLChatSessionWriter >> initialize [
	super initialize.
	encoder := GtLDataSourceEncoderDecoder new.
	mutex := Mutex new
]

{ #category : #accessing }
GtLChatSessionWriter >> lastRequestResponse [
	"Answer the last GtLRequestResponse written to the file, or nil"

	^ lastRequestResponse
]

{ #category : #'announcement handling' }
GtLChatSessionWriter >> onExecutionStateChanged: aGtLChatExecutionStateChanged [
	aGtLChatExecutionStateChanged state
		ifCanStop: [  ]
		ifStopping: [  ]
		ifIdle: [ self writeLatest ]
]

{ #category : #printing }
GtLChatSessionWriter >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self file basename;
		nextPut: $)
]

{ #category : #private }
GtLChatSessionWriter >> rollbackTo: bytePosition [
	"Close append streams before rollback, preventing buffered fragments from
	being re-flushed afterwards. Use the native disk stream's byte truncation;
	memory streams expose truncation via their file handle instead."

	| stream handle |
	self file exists ifFalse: [ ^ self ].
	stream := self file unbufferedBinaryWriteStream.
	(stream respondsTo: #truncate:)
		ifTrue: [ [ stream truncate: bytePosition ] ensure: [ stream close ] ]
		ifFalse: [ stream close.
			handle := self file openWritable: true.
			[ handle truncateTo: bytePosition ] ensure: [ handle close ] ]
]

{ #category : #subscriptions }
GtLChatSessionWriter >> subscribe [
	chat
		when: GtLChatExecutionStateChanged
		send: #onExecutionStateChanged:
		to: self
]

{ #category : #subscriptions }
GtLChatSessionWriter >> unsubscribe [
	chat ifNotNil: [ chat announcer unsubscribe: self ]
]

{ #category : #private }
GtLChatSessionWriter >> unwrittenRequestResponses [
	"Answer the request / responses in the chat's history that haven't been written yet.
	If nothing has been recorded as written, or the last written item is no longer in the history (e.g. it has been cleared), answer the entire history"

	| history index |
	history := self history.
	lastRequestResponse ifNil: [ ^ history copy ].
	index := history identityIndexOf: lastRequestResponse.
	index = 0 ifTrue: [ ^ history copy ].
	^ history allButFirst: index
]

{ #category : #writing }
GtLChatSessionWriter >> writeLatest [
	"Stage records before touching the file; checkpoint after flush and close.
	Rollback happens after unwinding the append stream, using byte offsets.
	Requires exclusive ownership of the file; does not guarantee crash durability."

	mutex
		critical: [ recoveryFailure ifNotNil: [ recoveryFailure signal ].
			self unwrittenRequestResponses
				do: [ :record | 
					| bytes position writeFailure |
					bytes := (String
							streamContents: [ :stream | encoder encode: record on: stream ])
							utf8Encoded.
					position := self file exists ifTrue: [ self file size ] ifFalse: [ 0 ].
					[ self file
						binaryWriteStreamDo: [ :stream | 
							stream setToEnd.
							self appendBytes: bytes on: stream.
							self flushStream: stream ] ]
						on: Error
						do: [ :error | writeFailure := error ].
					writeFailure
						ifNotNil: [ [ self rollbackTo: position ]
								on: Error
								do: [ :rollbackError | 
									recoveryFailure := GtLChatSessionWriterRecoveryError new
											writeError: writeFailure
											rollbackError: rollbackError ].
							recoveryFailure ifNotNil: [ recoveryFailure signal ].
							writeFailure signal ].
					lastRequestResponse := record ] ]
]
