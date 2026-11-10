"
Examples for {{gtClass:GtLChatSessionWriter}}.

The chats are populated directly through their client history, and idle state changes are signalled manually, so no LLM is contacted.  Files are written to an in-memory file system.
"
Class {
	#name : #GtLChatSessionWriterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-DataSource-Examples'
}

{ #category : #private }
GtLChatSessionWriterExamples >> addRequestText: aString to: aGtLChat [
	"Add a request / response pair to the chat's client history, simulating a completed LLM call"

	| request response |
	request := ZnRequest post: 'https://api.openai.com/v1/responses'.
	request
		entity: (ZnStringEntity
				json: '{"model":"gpt-4.1","input":[{"role":"user","content":[{"type":"input_text","text":"'
						, aString , '"}]}]}').
	response := ZnResponse
			ok: (ZnStringEntity
					json: '{"output":[{"type":"message","role":"assistant","content":[{"type":"output_text","text":"Reply to '
							, aString , '"}]}]}').
	^ aGtLChat provider client history addRequest: request response: response
]

{ #category : #examples }
GtLChatSessionWriterExamples >> automaticSessionWriterDisabled [
	<gtExample>
	| previous chat |
	previous := GtLChat startSessionWriter.
	[ GtLChat startSessionWriter: false.
	chat := GtLChat new.
	self assert: chat sessionWriters isEmpty ]
		ensure: [ GtLChat startSessionWriter: previous ].
	^ chat
]

{ #category : #examples }
GtLChatSessionWriterExamples >> automaticSessionWriterEnabled [
	<gtExample>
	| previous chat writer file |
	previous := GtLChat startSessionWriter.
	[ GtLChat startSessionWriter: true.
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	self assert: chat sessionWriters size equals: 1.
	writer := chat sessionWriters anyOne.
	file := self memoryFile.
	writer file: file.
	self assert: file exists not.
	self addRequestText: 'one' to: chat.
	chat signalExecutionStateChanged.
	self assert: (self requestTextsIn: file) equals: #('one').
	chat signalExecutionStateChanged.
	self assert: (self requestTextsIn: file) equals: #('one') ]
		ensure: [ chat ifNotNil: [ chat stopAllSessionWriters ].
			GtLChat startSessionWriter: previous ].
	^ writer
]

{ #category : #'examples - setup' }
GtLChatSessionWriterExamples >> chatWithTwoRequests [
	<gtExample>
	<return: #GtLChat>
	| chat |
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	self addRequestText: 'one' to: chat.
	self addRequestText: 'two' to: chat.
	self assert: chat provider client history size equals: 2.
	self
		assert: (chat state
				ifCanStop: [ false ]
				ifStopping: [ false ]
				ifIdle: [ true ]).
	^ chat
]

{ #category : #examples }
GtLChatSessionWriterExamples >> clearedHistoryIsWrittenInFull [
	"If the last written request / response is no longer in the history (e.g. it was cleared), the whole current history is appended"

	<gtExample>
	<return: #GtLChatSessionWriter>
	| writer |
	writer := self firstIdleWritesAllRequests.
	writer chat provider client history removeAll.
	self addRequestText: 'after clear' to: writer chat.
	writer chat signalExecutionStateChanged.
	self
		assert: (self requestTextsIn: writer file)
		equals: #('one' 'two' 'after clear').
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> defaultFileName [
	"Filename inspection on an empty client history does not create a disk file."

	<gtExample>
	| chat writer |
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	chat addMessage: (chat createUserMessage string: 'one').
	writer := GtLChatSessionWriter forChat: chat.
	[ self
		assert: (writer file basename
				matchesRegex: '\d\d\d\d-\d\d-\d\d_\d\d\d\d\d\d_.*_chat\.jsonl').
	self
		assert: (writer file basename endsWith: '_' , chat uid asString , '_chat.jsonl').
	self assert: writer file == writer file.
	self assert: writer file exists not ] ensure: [ writer unsubscribe ].
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> diskRollback [
	"Exercise real byte-based truncation as well as the memory filesystem."

	<gtExample>
	| file writer |
	file := FileReference newTempFilePrefix: 'session-rollback-' suffix: '.jsonl'.
	[ writer := self
			retryAfter: #write
			on: file
			withExistingRecord: true.
	file ensureDelete.
	self
		retryAfter: #flush
		on: file
		withExistingRecord: true ] ensure: [ file ensureDelete ].
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> distinctChatFileNames [
	"Independent chats have different suffixes even when timestamps coincide."

	<gtExample>
	| first second |
	first := self defaultFileName.
	second := self defaultFileName.
	self assert: first chat uid ~= second chat uid.
	self assert: first file ~= second file.
	^ {first.
		second}
]

{ #category : #examples }
GtLChatSessionWriterExamples >> emptyChatFileNames [
	"Empty chats get unique, cached filenames without creating files."

	<gtExample>
	| first second |
	first := GtLChatSessionWriter
			forChat: (GtLChat new provider: GtLOpenAiResponsesProvider new).
	second := GtLChatSessionWriter
			forChat: (GtLChat new provider: GtLOpenAiResponsesProvider new).
	[ self assert: first chat uid isNil.
	self assert: second chat uid isNil.
	self assert: first file ~= second file.
	self assert: first file == first file.
	self assert: first file exists not.
	self assert: second file exists not ]
		ensure: [ first unsubscribe.
			second unsubscribe ].
	^ {first.
		second}
]

{ #category : #examples }
GtLChatSessionWriterExamples >> encodingFailureBeforeFirstRecord [
	"A failed first record leaves the checkpoint unchanged and can be retried."

	<gtExample>
	| chat writer encoder record failed |
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	writer := GtLChatSessionWriter forChat: chat file: self memoryFile.
	writer unsubscribe.
	record := self addRequestText: 'one' to: chat.
	encoder := GtLChatSessionWriterExampleEncoder new.
	encoder
		beforeEncode: [ :each :stream | Error signal: 'Injected encoding failure' ].
	writer instVarNamed: 'encoder' put: encoder.
	failed := false.
	[ writer writeLatest ]
		on: Error
		do: [ :error | 
			self assert: error messageText equals: 'Injected encoding failure'.
			failed := true ].
	self assert: failed.
	self assert: writer lastRequestResponse isNil.
	self assert: writer file exists not.
	encoder beforeEncode: nil.
	writer writeLatest.
	self assert: writer lastRequestResponse == record.
	self assert: (self requestTextsIn: writer file) equals: #('one').
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> encodingFailurePreservesCompletedRecords [
	"The first record is flushed and checkpointed before encoding the second.
	Retrying a failure before the second record starts must not duplicate the first."

	<gtExample>
	| chat writer encoder first second failed |
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	writer := GtLChatSessionWriter forChat: chat file: self memoryFile.
	writer unsubscribe.
	first := self addRequestText: 'one' to: chat.
	second := self addRequestText: 'two' to: chat.
	encoder := GtLChatSessionWriterExampleEncoder new.
	encoder
		beforeEncode: [ :record :stream | 
			record == second
				ifTrue: [ self assert: writer lastRequestResponse == first.
					self assert: (self requestTextsIn: writer file) equals: #('one').
					Error signal: 'Injected encoding failure' ] ].
	writer instVarNamed: 'encoder' put: encoder.
	failed := false.
	[ writer writeLatest ]
		on: Error
		do: [ :error | 
			self assert: error messageText equals: 'Injected encoding failure'.
			failed := true ].
	self assert: failed.
	self assert: writer lastRequestResponse == first.
	self assert: writer unwrittenRequestResponses asArray equals: {second}.
	self assert: (self requestTextsIn: writer file) equals: #('one').
	encoder beforeEncode: nil.
	writer writeLatest.
	self assert: (self requestTextsIn: writer file) equals: #('one' 'two').
	self assert: writer lastRequestResponse == second.
	writer writeLatest.
	self assert: (self requestTextsIn: writer file) equals: #('one' 'two').
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> firstFlushRollback [
	<gtExample>
	^ self
		retryAfter: #flush
		on: self memoryFile
		withExistingRecord: false
]

{ #category : #examples }
GtLChatSessionWriterExamples >> firstIdleWritesAllRequests [
	"Attaching while running defers writing until the first idle announcement."

	<gtExample>
	<return: #GtLChatSessionWriter>
	| chat writer file |
	chat := self chatWithTwoRequests.
	chat provider privateExecutionState: GtLProviderState running.
	file := self memoryFile.
	writer := GtLChatSessionWriter forChat: chat file: file.
	self assert: file exists not.
	self assert: writer lastRequestResponse isNil.
	chat provider privateExecutionState: GtLProviderState idle.
	chat signalExecutionStateChanged.
	self assert: file exists.
	self assert: (self requestTextsIn: file) equals: #('one' 'two').
	self assert: writer lastRequestResponse == chat provider client history last.
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> firstWriteRollback [
	<gtExample>
	^ self
		retryAfter: #write
		on: self memoryFile
		withExistingRecord: false
]

{ #category : #examples }
GtLChatSessionWriterExamples >> flushFailureRollback [
	<gtExample>
	^ self
		retryAfter: #flush
		on: self memoryFile
		withExistingRecord: true
]

{ #category : #examples }
GtLChatSessionWriterExamples >> idleAppendsNewRequests [
	"Only the request / responses added since the last write are appended"

	<gtExample>
	<return: #GtLChatSessionWriter>
	| writer third |
	writer := self firstIdleWritesAllRequests.
	third := self addRequestText: 'three' to: writer chat.
	writer chat signalExecutionStateChanged.
	self assert: (self requestTextsIn: writer file) equals: #('one' 'two' 'three').
	self assert: writer lastRequestResponse == third.
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> idleWithoutNewRequestsWritesNothing [
	"An idle announcement after the immediate startup write does not duplicate history."

	<gtExample>
	<return: #GtLChatSessionWriter>
	| writer contents |
	writer := self writerForChat.
	contents := writer file contents.
	writer chat signalExecutionStateChanged.
	self assert: writer file contents equals: contents.
	^ writer
]

{ #category : #'examples - setup' }
GtLChatSessionWriterExamples >> memoryFile [
	<gtExample>
	<return: #FileReference>
	| file |
	file := FileSystem memory / 'session_chat.jsonl'.
	self assert: file exists not.
	^ file
]

{ #category : #examples }
GtLChatSessionWriterExamples >> nonIdleStateWritesNothing [
	"Non-idle attachment and announcements do not write history."

	<gtExample>
	| writer |
	{GtLProviderState scheduled.
		GtLProviderState running.
		GtLProviderState stopping}
		do: [ :aState | 
			| chat file |
			chat := self chatWithTwoRequests.
			chat provider privateExecutionState: aState.
			file := self memoryFile.
			writer := GtLChatSessionWriter forChat: chat file: file.
			[ chat signalExecutionStateChanged.
			self assert: file exists not.
			self assert: writer lastRequestResponse isNil ]
				ensure: [ writer unsubscribe ] ].
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> partialEncodingDoesNotTouchFile [
	<gtExample>
	| writer encoder before failed |
	writer := self writerForChat.
	writer unsubscribe.
	before := writer file binaryContents.
	self addRequestText: 'three' to: writer chat.
	encoder := GtLChatSessionWriterExampleEncoder new.
	encoder
		beforeEncode: [ :record :stream | 
			stream nextPutAll: '{incomplete'.
			Error signal: 'Injected partial encoding failure' ].
	writer instVarNamed: 'encoder' put: encoder.
	failed := false.
	[ writer writeLatest ]
		on: Error
		do: [ :error | 
			self assert: error messageText equals: 'Injected partial encoding failure'.
			failed := true ].
	self assert: failed.
	self assert: writer file binaryContents equals: before.
	encoder beforeEncode: nil.
	writer writeLatest.
	self assert: (self requestTextsIn: writer file) equals: #('one' 'two' 'three').
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> partialWriteRollback [
	<gtExample>
	^ self
		retryAfter: #write
		on: self memoryFile
		withExistingRecord: true
]

{ #category : #examples }
GtLChatSessionWriterExamples >> reconstructionWithAutomaticSessionWriter [
	"Replaying a file must not write historical messages or duplicate writers."

	<gtExample>
	| previous source file chat writer output original result |
	previous := GtLChat startSessionWriter.
	[ GtLChat startSessionWriter: false.
	source := self chatWithTwoRequests.
	source provider client history
		do: [ :record | 
			record request
				entity: (ZnStringEntity
						json: (record request entity contents
								copyReplaceAll: '{"model"'
								with: '{"tools":[],"model"')).
			record result: record response asGtJson jsonObject ].
	file := self memoryFile.
	file
		writeStreamDo: [ :stream | 
			GtLDataSourceEncoderDecoder
				saveClientHistory: source provider client history
				toStream: stream ].
	original := file contents.
	GtLChat startSessionWriter: true.
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	self assert: chat sessionWriters size equals: 1.
	writer := chat sessionWriters anyOne.
	output := FileSystem memory root / 'continued.jsonl'.
	writer file: output.
	result := GtLDataSourceEncoderDecoder recreateChatFrom: file chat: chat.
	self assert: result == chat.
	self assert: chat messages isEmpty not.
	self assert: chat sessionWriters size equals: 1.
	self assert: chat sessionWriters anyOne == writer.
	self assert: file contents equals: original.
	self assert: output exists not.
	chat signalExecutionStateChanged.
	self assert: output exists not.
	self addRequestText: 'continued' to: chat.
	chat signalExecutionStateChanged.
	self assert: (self requestTextsIn: output) equals: #('continued').
	self assert: file contents equals: original ]
		ensure: [ chat ifNotNil: [ chat stopAllSessionWriters ].
			GtLChat startSessionWriter: previous ].
	^ chat
]

{ #category : #private }
GtLChatSessionWriterExamples >> requestTextsIn: aFileReference [
	"Answer the user input text of each request recorded in aFileReference"

	^ (GtLDataSourceEncoderDecoder loadClientHistoryFrom: aFileReference)
		collect: [ :each | 
			(((STONJSON fromString: each request contents) at: 'input') first at: 'content')
				first at: 'text' ]
		as: Array
]

{ #category : #private }
GtLChatSessionWriterExamples >> retryAfter: failureMode on: file withExistingRecord: hasRecord [
	| chat writer first second before failed |
	chat := GtLChat new provider: GtLOpenAiResponsesProvider new.
	writer := GtLChatSessionWriterExampleWriter forChat: chat file: file.
	writer unsubscribe.
	hasRecord
		ifTrue: [ first := self addRequestText: 'café ýžřč' to: chat.
			writer writeLatest ].
	before := file exists ifTrue: [ file binaryContents ] ifFalse: [ #[] ].
	second := self addRequestText: 'string ščřž é' to: chat.
	writer failureMode: failureMode.
	failed := false.
	[ writer writeLatest ]
		on: Error
		do: [ :error | 
			self assert: error messageText equals: 'Injected ' , failureMode , ' failure'.
			failed := true ].
	self assert: failed.
	self assert: file binaryContents equals: before.
	self assert: writer lastRequestResponse == first.
	writer failureMode: nil.
	writer writeLatest.
	self assert: writer lastRequestResponse == second.
	self
		assert: (self requestTextsIn: file)
		equals: (hasRecord ifTrue: [ #('café ýžřč' 'string ščřž é') ] ifFalse: [ #('string ščřž é') ]).
	writer writeLatest.
	self
		assert: (self requestTextsIn: file) size
		equals: (hasRecord ifTrue: [ 2 ] ifFalse: [ 1 ]).
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> rollbackFailureDisablesWriter [
	<gtExample>
	| writer chat before failure |
	chat := self chatWithTwoRequests.
	writer := GtLChatSessionWriterExampleWriter forChat: chat file: self memoryFile.
	writer unsubscribe.
	self addRequestText: 'three' to: chat.
	before := writer lastRequestResponse.
	writer failureMode: #rollback.
	[ writer writeLatest ]
		on: GtLChatSessionWriterRecoveryError
		do: [ :error | failure := error ].
	self assert: failure notNil.
	self assert: failure writeError messageText equals: 'Injected write failure'.
	self
		assert: failure rollbackError messageText
		equals: 'Injected rollback failure'.
	self assert: writer lastRequestResponse == before.
	before := writer file binaryContents.
	writer failureMode: nil.
	[ writer writeLatest.
	self error: 'Expected disabled writer' ]
		on: GtLChatSessionWriterRecoveryError
		do: [ :error | self assert: error == failure ].
	self assert: writer file binaryContents equals: before.
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> unsubscribedWriterWritesNothing [
	<gtExample>
	| writer contents |
	writer := self writerForChat.
	contents := writer file contents.
	writer unsubscribe.
	self addRequestText: 'three' to: writer chat.
	writer chat signalExecutionStateChanged.
	self assert: writer file contents equals: contents.
	^ writer
]

{ #category : #examples }
GtLChatSessionWriterExamples >> writerForChat [
	"Attaching to an idle chat immediately writes its existing history."

	<gtExample>
	<return: #GtLChatSessionWriter>
	| chat file writer |
	chat := self chatWithTwoRequests.
	file := self memoryFile.
	writer := GtLChatSessionWriter forChat: chat file: file.
	self assert: writer chat == chat.
	self assert: writer file equals: file.
	self assert: file exists.
	self assert: (self requestTextsIn: file) equals: #('one' 'two').
	self assert: writer lastRequestResponse == chat provider client history last.
	^ writer
]
