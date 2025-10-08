! Class Declarations
! Generated file, do not Edit

doit
(Announcement
	subclass: 'GtLlmActionCall'
	instVarNames: #(action arguments subject)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionCall
removeallclassmethods GtLlmActionCall

doit
(Announcement
	subclass: 'GtLlmMessageContentsUpdated'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmMessageContentsUpdated
removeallclassmethods GtLlmMessageContentsUpdated

doit
(Announcement
	subclass: 'GtLlmNewThreadMessageContentsChanged'
	instVarNames: #(threadMessage contents requester)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNewThreadMessageContentsChanged
removeallclassmethods GtLlmNewThreadMessageContentsChanged

doit
(Announcement
	subclass: 'GtLlmThreadMessageRestyleRequested'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmThreadMessageRestyleRequested
removeallclassmethods GtLlmThreadMessageRestyleRequested

doit
(Announcement
	subclass: 'GtLlmThreadMessageViewModelChanged'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmThreadMessageViewModelChanged
removeallclassmethods GtLlmThreadMessageViewModelChanged

doit
(Announcement
	subclass: 'GtLlmThreadRunAnnouncement'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmThreadRunAnnouncement
removeallclassmethods GtLlmThreadRunAnnouncement

doit
(GtLlmThreadRunAnnouncement
	subclass: 'GtLlmThreadRunIsDoneAnnouncement'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmThreadRunIsDoneAnnouncement
removeallclassmethods GtLlmThreadRunIsDoneAnnouncement

doit
(GtLlmThreadRunAnnouncement
	subclass: 'GtLlmThreadRunStartedAnnouncement'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmThreadRunStartedAnnouncement
removeallclassmethods GtLlmThreadRunStartedAnnouncement

doit
(GtLlmThreadRunAnnouncement
	subclass: 'GtOpenAIThreadRunUpdatedAnnouncement'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIThreadRunUpdatedAnnouncement
removeallclassmethods GtOpenAIThreadRunUpdatedAnnouncement

doit
(Announcement
	subclass: 'GtSharedStringUpdated'
	instVarNames: #(string)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtSharedStringUpdated
removeallclassmethods GtSharedStringUpdated

doit
(Error
	subclass: 'GtLlmError'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmError
removeallclassmethods GtLlmError

doit
(GtLlmError
	subclass: 'GtOllamaError'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaError
removeallclassmethods GtOllamaError

doit
(GtLlmError
	subclass: 'GtOpenAIError'
	instVarNames: #(type param code)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIError
removeallclassmethods GtOpenAIError

doit
(Object
	subclass: 'GtBPEEncoder'
	instVarNames: #(vocabularySize)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtBPEEncoder
removeallclassmethods GtBPEEncoder

doit
(Object
	subclass: 'GtBPEEncoderExamples'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtBPEEncoderExamples
removeallclassmethods GtBPEEncoderExamples

doit
(Object
	subclass: 'GtBPEEncodingResult'
	instVarNames: #(input tokens stats merges output)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtBPEEncodingResult
removeallclassmethods GtBPEEncodingResult

doit
(Object
	subclass: 'GtBPEMergeResult'
	instVarNames: #(merges output)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtBPEMergeResult
removeallclassmethods GtBPEMergeResult

doit
(Object
	subclass: 'GtLlmActionCallExamples'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionCallExamples
removeallclassmethods GtLlmActionCallExamples

doit
(Object
	subclass: 'GtLlmActionReference'
	instVarNames: #(action isInput isOutput)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionReference
removeallclassmethods GtLlmActionReference

doit
(Object
	subclass: 'GtLlmAssistant'
	instVarNames: #(instruction connection)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistant
removeallclassmethods GtLlmAssistant

doit
(GtLlmAssistant
	subclass: 'GtLlmTutor'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmTutor
removeallclassmethods GtLlmTutor

doit
(GtLlmAssistant
	subclass: 'GtOpenAIBlogPostAssistant'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIBlogPostAssistant
removeallclassmethods GtOpenAIBlogPostAssistant

doit
(Object
	subclass: 'GtLlmAssistantAction'
	instVarNames: #(name examples pipeline description format priority definingMethod assistant arguments)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantAction
removeallclassmethods GtLlmAssistantAction

doit
(Object
	subclass: 'GtLlmAssistantActionExample'
	instVarNames: #(input output inputReferences action outputReferences unverified)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantActionExample
removeallclassmethods GtLlmAssistantActionExample

doit
(Object
	subclass: 'GtLlmAssistantChatStatus'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantChatStatus
removeallclassmethods GtLlmAssistantChatStatus

doit
(GtLlmAssistantChatStatus
	subclass: 'GtLlmAssistantChatDynamicStatus'
	instVarNames: #(threadRun)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantChatDynamicStatus
removeallclassmethods GtLlmAssistantChatDynamicStatus

doit
(GtLlmAssistantChatStatus
	subclass: 'GtLlmAssistantChatNotReadyStatus'
	instVarNames: #()
	classVars: #()
	classInstVars: #(uniqueInstance)
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantChatNotReadyStatus
removeallclassmethods GtLlmAssistantChatNotReadyStatus

doit
(GtLlmAssistantChatStatus
	subclass: 'GtLlmAssistantChatReadyStatus'
	instVarNames: #()
	classVars: #()
	classInstVars: #(uniqueInstance)
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantChatReadyStatus
removeallclassmethods GtLlmAssistantChatReadyStatus

doit
(GtLlmAssistantChatStatus
	subclass: 'GtLlmAssistantChatWorkingStatus'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantChatWorkingStatus
removeallclassmethods GtLlmAssistantChatWorkingStatus

doit
(Object
	subclass: 'GtLlmAssistantExamples'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantExamples
removeallclassmethods GtLlmAssistantExamples

doit
(Object
	subclass: 'GtLlmAssistantFormatDescription'
	instVarNames: #(name format tag example priority referencingActions definingMethod type items assistant)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantFormatDescription
removeallclassmethods GtLlmAssistantFormatDescription

doit
(Object
	subclass: 'GtLlmAssistantInstruction'
	instVarNames: #(name actions description formats sections)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantInstruction
removeallclassmethods GtLlmAssistantInstruction

doit
(Object
	subclass: 'GtLlmChat'
	instVarNames: #(announcer lastUpdate assistant provider messages)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmChat
removeallclassmethods GtLlmChat

doit
(GtLlmChat
	subclass: 'GtLlmActionChat'
	instVarNames: #(instance)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionChat
removeallclassmethods GtLlmActionChat

doit
(Object
	subclass: 'GtLlmChatExamples'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmChatExamples
removeallclassmethods GtLlmChatExamples

doit
(Object
	subclass: 'GtLlmConnection'
	instVarNames: #(provider label meta)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmConnection
removeallclassmethods GtLlmConnection

doit
(Object
	subclass: 'GtLlmConnectionRegistry'
	instVarNames: #(connections defaultConnection)
	classVars: #()
	classInstVars: #(uniqueInstance)
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmConnectionRegistry
removeallclassmethods GtLlmConnectionRegistry

doit
(Object
	subclass: 'GtLlmDistanceMetric'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmDistanceMetric
removeallclassmethods GtLlmDistanceMetric

doit
(GtLlmDistanceMetric
	subclass: 'GtLlmChebyshevDistanceMetric'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmChebyshevDistanceMetric
removeallclassmethods GtLlmChebyshevDistanceMetric

doit
(GtLlmDistanceMetric
	subclass: 'GtLlmCityBlockDistanceMetric'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmCityBlockDistanceMetric
removeallclassmethods GtLlmCityBlockDistanceMetric

doit
(GtLlmDistanceMetric
	subclass: 'GtLlmCorrelationDistanceMetric'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmCorrelationDistanceMetric
removeallclassmethods GtLlmCorrelationDistanceMetric

doit
(GtLlmDistanceMetric
	subclass: 'GtLlmCosineDistanceMetric'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmCosineDistanceMetric
removeallclassmethods GtLlmCosineDistanceMetric

doit
(Object
	subclass: 'GtLlmEmbedding'
	instVarNames: #(input embedding)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmEmbedding
removeallclassmethods GtLlmEmbedding

doit
(Object
	subclass: 'GtLlmEmbeddingRegistry'
	instVarNames: #(embeddings)
	classVars: #()
	classInstVars: #(uniqueInstance)
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmEmbeddingRegistry
removeallclassmethods GtLlmEmbeddingRegistry

doit
(Object
	subclass: 'GtLlmEmbeddingsUtilities'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmEmbeddingsUtilities
removeallclassmethods GtLlmEmbeddingsUtilities

doit
(Object
	subclass: 'GtLlmEndpointClient'
	instVarNames: #(client)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmEndpointClient
removeallclassmethods GtLlmEndpointClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaCompleteChatAPIClient'
	instVarNames: #(messages model format tools instructions)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaCompleteChatAPIClient
removeallclassmethods GtOllamaCompleteChatAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaCreateModelClient'
	instVarNames: #(model modelFile)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaCreateModelClient
removeallclassmethods GtOllamaCreateModelClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaDeleteModelClient'
	instVarNames: #(model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaDeleteModelClient
removeallclassmethods GtOllamaDeleteModelClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaGenerateEmbeddingsAPIClient'
	instVarNames: #(input model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaGenerateEmbeddingsAPIClient
removeallclassmethods GtOllamaGenerateEmbeddingsAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaGenerateResponseClient'
	instVarNames: #(model prompt suffix images format options system template stream raw keep_alive)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		comment: 'Based on <https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion>.';
		immediateInvariant.
true.
%

removeallmethods GtOllamaGenerateResponseClient
removeallclassmethods GtOllamaGenerateResponseClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaGetModelInformationAPIClient'
	instVarNames: #(model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaGetModelInformationAPIClient
removeallclassmethods GtOllamaGetModelInformationAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaListModelsClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaListModelsClient
removeallclassmethods GtOllamaListModelsClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaListRunningModelsClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaListRunningModelsClient
removeallclassmethods GtOllamaListRunningModelsClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaPullModelClient'
	instVarNames: #(model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaPullModelClient
removeallclassmethods GtOllamaPullModelClient

doit
(GtLlmEndpointClient
	subclass: 'GtOllamaPushModelClient'
	instVarNames: #(model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaPushModelClient
removeallclassmethods GtOllamaPushModelClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIAddMessageToThreadAPIClient'
	instVarNames: #(message thread)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAddMessageToThreadAPIClient
removeallclassmethods GtOpenAIAddMessageToThreadAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICompleteChatAPIClient'
	instVarNames: #(model messages)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICompleteChatAPIClient
removeallclassmethods GtOpenAICompleteChatAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICreateAssistantAPIClient'
	instVarNames: #(assistant)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICreateAssistantAPIClient
removeallclassmethods GtOpenAICreateAssistantAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICreateAssistantFileAPIClient'
	instVarNames: #(file assistant)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICreateAssistantFileAPIClient
removeallclassmethods GtOpenAICreateAssistantFileAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICreateFineTuningJobAPIClient'
	instVarNames: #(model file)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICreateFineTuningJobAPIClient
removeallclassmethods GtOpenAICreateFineTuningJobAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICreateThreadAPIClient'
	instVarNames: #(messages)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICreateThreadAPIClient
removeallclassmethods GtOpenAICreateThreadAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICreateThreadRunAPIClient'
	instVarNames: #(assistant thread responseFormat)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICreateThreadRunAPIClient
removeallclassmethods GtOpenAICreateThreadRunAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAICreateVectorStoreAPIClient'
	instVarNames: #(name files)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAICreateVectorStoreAPIClient
removeallclassmethods GtOpenAICreateVectorStoreAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIDeleteAssistantAPIClient'
	instVarNames: #(assistant)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIDeleteAssistantAPIClient
removeallclassmethods GtOpenAIDeleteAssistantAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIDeleteFileAPIClient'
	instVarNames: #(file)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIDeleteFileAPIClient
removeallclassmethods GtOpenAIDeleteFileAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIDeleteModelAPIClient'
	instVarNames: #(model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIDeleteModelAPIClient
removeallclassmethods GtOpenAIDeleteModelAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIDeleteVectorStoreAPIClient'
	instVarNames: #(vectorStore)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIDeleteVectorStoreAPIClient
removeallclassmethods GtOpenAIDeleteVectorStoreAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIGenerateEmbeddingAPIClient'
	instVarNames: #(input model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGenerateEmbeddingAPIClient
removeallclassmethods GtOpenAIGenerateEmbeddingAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIGenerateResponseAPIClient'
	instVarNames: #(model messages tools format instructions isStreaming)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGenerateResponseAPIClient
removeallclassmethods GtOpenAIGenerateResponseAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIGetFileAPIClient'
	instVarNames: #(file)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGetFileAPIClient
removeallclassmethods GtOpenAIGetFileAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIGetFileContentsAPIClient'
	instVarNames: #(file)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGetFileContentsAPIClient
removeallclassmethods GtOpenAIGetFileContentsAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIGetFineTuningJobAPIClient'
	instVarNames: #(job)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGetFineTuningJobAPIClient
removeallclassmethods GtOpenAIGetFineTuningJobAPIClient

doit
(GtOpenAIGetFineTuningJobAPIClient
	subclass: 'GtOpenAIGetFineTuningCheckpointsForJobAPIClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGetFineTuningCheckpointsForJobAPIClient
removeallclassmethods GtOpenAIGetFineTuningCheckpointsForJobAPIClient

doit
(GtOpenAIGetFineTuningJobAPIClient
	subclass: 'GtOpenAIGetFineTuningEventsForJobAPIClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGetFineTuningEventsForJobAPIClient
removeallclassmethods GtOpenAIGetFineTuningEventsForJobAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIGetThreadRunAPIClient'
	instVarNames: #(run thread)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGetThreadRunAPIClient
removeallclassmethods GtOpenAIGetThreadRunAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIListAssistantsAPIClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIListAssistantsAPIClient
removeallclassmethods GtOpenAIListAssistantsAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIListFilesAPIClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIListFilesAPIClient
removeallclassmethods GtOpenAIListFilesAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIListModelsAPIClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIListModelsAPIClient
removeallclassmethods GtOpenAIListModelsAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIListThreadMessagesAPIClient'
	instVarNames: #(thread params)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIListThreadMessagesAPIClient
removeallclassmethods GtOpenAIListThreadMessagesAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIListVectorStoresAPIClient'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIListVectorStoresAPIClient
removeallclassmethods GtOpenAIListVectorStoresAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAISubmitToolOutputsAPIClient'
	instVarNames: #(thread run outputs)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAISubmitToolOutputsAPIClient
removeallclassmethods GtOpenAISubmitToolOutputsAPIClient

doit
(GtLlmEndpointClient
	subclass: 'GtOpenAIUploadFileAPIClient'
	instVarNames: #(file purpose)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIUploadFileAPIClient
removeallclassmethods GtOpenAIUploadFileAPIClient

doit
(Object
	subclass: 'GtLlmEntity'
	instVarNames: #(rawData client)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmEntity
removeallclassmethods GtLlmEntity

doit
(GtLlmEntity
	subclass: 'GtLlmChatMessage'
	instVarNames: #(content role id createdAt chat announcer images model)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmChatMessage
removeallclassmethods GtLlmChatMessage

doit
(GtLlmChatMessage
	subclass: 'GtLlmActionMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionMessage
removeallclassmethods GtLlmActionMessage

doit
(GtLlmChatMessage
	subclass: 'GtLlmAssistantMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantMessage
removeallclassmethods GtLlmAssistantMessage

doit
(GtLlmChatMessage
	subclass: 'GtLlmSystemMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmSystemMessage
removeallclassmethods GtLlmSystemMessage

doit
(GtLlmChatMessage
	subclass: 'GtLlmToolMessage'
	instVarNames: #(toolCall output)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmToolMessage
removeallclassmethods GtLlmToolMessage

doit
(GtLlmChatMessage
	subclass: 'GtLlmUserMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmUserMessage
removeallclassmethods GtLlmUserMessage

doit
(GtLlmChatMessage
	subclass: 'GtOpenAIMessage'
	instVarNames: #(threadId assistantId runId metadata annotations pipeline step completedAt incompleteAt)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIMessage
removeallclassmethods GtOpenAIMessage

doit
(GtOpenAIMessage
	subclass: 'GtOpenAIActionMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIActionMessage
removeallclassmethods GtOpenAIActionMessage

doit
(GtOpenAIActionMessage
	subclass: 'GtOpenAIBlogPostMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIBlogPostMessage
removeallclassmethods GtOpenAIBlogPostMessage

doit
(GtLlmEntity
	subclass: 'GtLlmFunctionToolCall'
	instVarNames: #(id arguments name tool)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFunctionToolCall
removeallclassmethods GtLlmFunctionToolCall

doit
(GtLlmEntity
	subclass: 'GtLlmTool'
	instVarNames: #(type name)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmTool
removeallclassmethods GtLlmTool

doit
(GtLlmTool
	subclass: 'GtLlmFileSearchTool'
	instVarNames: #(vectorStoreIds)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFileSearchTool
removeallclassmethods GtLlmFileSearchTool

doit
(GtLlmTool
	subclass: 'GtLlmFunctionTool'
	instVarNames: #(description parameters block)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFunctionTool
removeallclassmethods GtLlmFunctionTool

doit
(GtLlmFunctionTool
	subclass: 'GtLlmFunctionToolWithProtocol'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFunctionToolWithProtocol
removeallclassmethods GtLlmFunctionToolWithProtocol

doit
(GtLlmEntity
	subclass: 'GtOllamaEmbedding'
	instVarNames: #(embedding)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaEmbedding
removeallclassmethods GtOllamaEmbedding

doit
(GtLlmEntity
	subclass: 'GtOllamaModel'
	instVarNames: #(name model modifiedAt size digest details)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaModel
removeallclassmethods GtOllamaModel

doit
(GtLlmEntity
	subclass: 'GtOllamaModelInformation'
	instVarNames: #(modelfile parameters template details modelInfo license)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaModelInformation
removeallclassmethods GtOllamaModelInformation

doit
(GtLlmEntity
	subclass: 'GtOllamaResponseMessage'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaResponseMessage
removeallclassmethods GtOllamaResponseMessage

doit
(GtLlmEntity
	subclass: 'GtOllamaRunningModel'
	instVarNames: #(name model expiresAt size sizeVram digest details)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaRunningModel
removeallclassmethods GtOllamaRunningModel

doit
(GtLlmEntity
	subclass: 'GtOllamaStatusSteps'
	instVarNames: #(steps)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaStatusSteps
removeallclassmethods GtOllamaStatusSteps

doit
(GtLlmEntity
	subclass: 'GtOllamaThreadMessage'
	instVarNames: #(promptEvalDuration model createdAt evalDuration totalDuration loadDuration doneReason promptEvalCount evalCount message)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaThreadMessage
removeallclassmethods GtOllamaThreadMessage

doit
(GtLlmEntity
	subclass: 'GtOpenAIAnnotation'
	instVarNames: #(type text startIndex endIndex fileCitation message)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAnnotation
removeallclassmethods GtOpenAIAnnotation

doit
(GtLlmEntity
	subclass: 'GtOpenAIAssistant'
	instVarNames: #(id createdAt name description model instructions tools toolResources)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAssistant
removeallclassmethods GtOpenAIAssistant

doit
(GtLlmEntity
	subclass: 'GtOpenAIAssistantFile'
	instVarNames: #(id createdAt assistantId)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAssistantFile
removeallclassmethods GtOpenAIAssistantFile

doit
(GtLlmEntity
	subclass: 'GtOpenAIChatCompletion'
	instVarNames: #(id created model choices usage systemFingerprint)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIChatCompletion
removeallclassmethods GtOpenAIChatCompletion

doit
(GtLlmEntity
	subclass: 'GtOpenAIChatCompletionChoice'
	instVarNames: #(logProbs finishReason index message)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIChatCompletionChoice
removeallclassmethods GtOpenAIChatCompletionChoice

doit
(GtLlmEntity
	subclass: 'GtOpenAIDeletion'
	instVarNames: #(id object isDeleted)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIDeletion
removeallclassmethods GtOpenAIDeletion

doit
(GtLlmEntity
	subclass: 'GtOpenAIEmbedding'
	instVarNames: #(embedding)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIEmbedding
removeallclassmethods GtOpenAIEmbedding

doit
(GtLlmEntity
	subclass: 'GtOpenAIFile'
	instVarNames: #(id purpose filename bytes createdAt status statusDetails)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFile
removeallclassmethods GtOpenAIFile

doit
(GtLlmEntity
	subclass: 'GtOpenAIFileCitation'
	instVarNames: #(fileId quote annotation)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFileCitation
removeallclassmethods GtOpenAIFileCitation

doit
(GtLlmEntity
	subclass: 'GtOpenAIFineTuningCheckpoint'
	instVarNames: #(id createdAt fineTunedModelCheckpoint metrics fineTuningJobId stepNumber)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFineTuningCheckpoint
removeallclassmethods GtOpenAIFineTuningCheckpoint

doit
(GtLlmEntity
	subclass: 'GtOpenAIFineTuningEvent'
	instVarNames: #(id createdAt level message data type)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFineTuningEvent
removeallclassmethods GtOpenAIFineTuningEvent

doit
(GtLlmEntity
	subclass: 'GtOpenAIFineTuningJob'
	instVarNames: #(object id model createdAt fineTunedModel organizationId resultFiles status validationFile trainingFile finishedAt estimatedFinish)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFineTuningJob
removeallclassmethods GtOpenAIFineTuningJob

doit
(GtLlmEntity
	subclass: 'GtOpenAIModel'
	instVarNames: #(created object ownedBy id)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIModel
removeallclassmethods GtOpenAIModel

doit
(GtLlmEntity
	subclass: 'GtOpenAIResponse'
	instVarNames: #(id createdAt status error incompleteDetails instructions maxOutputTokens model output parallelToolCalls previousResponseId reasoning store temperature text toolChoice tools topP truncation usage user metadata)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIResponse
removeallclassmethods GtOpenAIResponse

doit
(GtLlmEntity
	subclass: 'GtOpenAIThread'
	instVarNames: #(id createdAt metadata messages tools toolResources)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIThread
removeallclassmethods GtOpenAIThread

doit
(GtLlmEntity
	subclass: 'GtOpenAIThreadRun'
	instVarNames: #(id createdAt assistantId threadId status startedAt expiresAt cancelledAt failedAt completedAt lastError model instructions tools fileIds metadata usage files)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIThreadRun
removeallclassmethods GtOpenAIThreadRun

doit
(GtLlmEntity
	subclass: 'GtOpenAIUsage'
	instVarNames: #(promptTokens completionTokens totalTokens)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIUsage
removeallclassmethods GtOpenAIUsage

doit
(GtLlmEntity
	subclass: 'GtOpenAIVectorStore'
	instVarNames: #(id name createdAt status usageBytes fileCounts)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIVectorStore
removeallclassmethods GtOpenAIVectorStore

doit
(Object
	subclass: 'GtLlmErrorThreadMessage'
	instVarNames: #(exception createdAt chat)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmErrorThreadMessage
removeallclassmethods GtLlmErrorThreadMessage

doit
(Object
	subclass: 'GtLlmFailureThreadMessage'
	instVarNames: #(failureText createdAt chat)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFailureThreadMessage
removeallclassmethods GtLlmFailureThreadMessage

doit
(Object
	subclass: 'GtLlmFeatures'
	instVarNames: #()
	classVars: #()
	classInstVars: #(UseCoder MultiStep)
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFeatures
removeallclassmethods GtLlmFeatures

doit
(Object
	subclass: 'GtLlmFineTuningFile'
	instVarNames: #(conversations model name)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFineTuningFile
removeallclassmethods GtLlmFineTuningFile

doit
(Object
	subclass: 'GtLlmGroup'
	instVarNames: #(items)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmGroup
removeallclassmethods GtLlmGroup

doit
(GtLlmGroup
	subclass: 'GtLlmActionsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionsGroup
removeallclassmethods GtLlmActionsGroup

doit
(GtLlmGroup
	subclass: 'GtLlmAssistantActionExamplesGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAssistantActionExamplesGroup
removeallclassmethods GtLlmAssistantActionExamplesGroup

doit
(GtLlmGroup
	subclass: 'GtLlmInspectorMethodSummaryGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInspectorMethodSummaryGroup
removeallclassmethods GtLlmInspectorMethodSummaryGroup

doit
(GtLlmGroup
	subclass: 'GtLlmInspectorSlotSummaryGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInspectorSlotSummaryGroup
removeallclassmethods GtLlmInspectorSlotSummaryGroup

doit
(GtLlmGroup
	subclass: 'GtLlmInspectorViewSummaryGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInspectorViewSummaryGroup
removeallclassmethods GtLlmInspectorViewSummaryGroup

doit
(GtLlmGroup
	subclass: 'GtLlmMessagePartGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmMessagePartGroup
removeallclassmethods GtLlmMessagePartGroup

doit
(GtLlmGroup
	subclass: 'GtLlmMessagesGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmMessagesGroup
removeallclassmethods GtLlmMessagesGroup

doit
(GtLlmGroup
	subclass: 'GtLlmNearestEmbeddingsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNearestEmbeddingsGroup
removeallclassmethods GtLlmNearestEmbeddingsGroup

doit
(GtLlmGroup
	subclass: 'GtLlmToolsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmToolsGroup
removeallclassmethods GtLlmToolsGroup

doit
(GtLlmGroup
	subclass: 'GtMcpPromptsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpPromptsGroup
removeallclassmethods GtMcpPromptsGroup

doit
(GtLlmGroup
	subclass: 'GtMcpResourcesGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpResourcesGroup
removeallclassmethods GtMcpResourcesGroup

doit
(GtLlmGroup
	subclass: 'GtOllamaEmbeddingsGroup'
	instVarNames: #(client)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaEmbeddingsGroup
removeallclassmethods GtOllamaEmbeddingsGroup

doit
(GtLlmGroup
	subclass: 'GtOllamaModelsGroup'
	instVarNames: #(client)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaModelsGroup
removeallclassmethods GtOllamaModelsGroup

doit
(GtLlmGroup
	subclass: 'GtOllamaRunningModelsGroup'
	instVarNames: #(client)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaRunningModelsGroup
removeallclassmethods GtOllamaRunningModelsGroup

doit
(GtLlmGroup
	subclass: 'GtOpenAIResourceFilesGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIResourceFilesGroup
removeallclassmethods GtOpenAIResourceFilesGroup

doit
(Object
	subclass: 'GtLlmInspectorMethodSummary'
	instVarNames: #(name)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInspectorMethodSummary
removeallclassmethods GtLlmInspectorMethodSummary

doit
(Object
	subclass: 'GtLlmInspectorSlotSummary'
	instVarNames: #(slot name slotValue)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInspectorSlotSummary
removeallclassmethods GtLlmInspectorSlotSummary

doit
(Object
	subclass: 'GtLlmInspectorSummary'
	instVarNames: #(objectClass slots views methods object)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInspectorSummary
removeallclassmethods GtLlmInspectorSummary

doit
(Object
	subclass: 'GtLlmInstructionPiece'
	instVarNames: #(parent source)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInstructionPiece
removeallclassmethods GtLlmInstructionPiece

doit
(GtLlmInstructionPiece
	subclass: 'GtLlmInstructionComposite'
	instVarNames: #(items)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInstructionComposite
removeallclassmethods GtLlmInstructionComposite

doit
(GtLlmInstructionPiece
	subclass: 'GtLlmInstructionList'
	instVarNames: #(items)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInstructionList
removeallclassmethods GtLlmInstructionList

doit
(GtLlmInstructionPiece
	subclass: 'GtLlmInstructionSection'
	instVarNames: #(title body headerLevel autoHeaderLevel)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInstructionSection
removeallclassmethods GtLlmInstructionSection

doit
(GtLlmInstructionPiece
	subclass: 'GtLlmInstructionString'
	instVarNames: #(string)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInstructionString
removeallclassmethods GtLlmInstructionString

doit
(GtLlmInstructionPiece
	subclass: 'GtLlmInstructionWithSections'
	instVarNames: #(introduction sections)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmInstructionWithSections
removeallclassmethods GtLlmInstructionWithSections

doit
(Object
	subclass: 'GtLlmMessagePart'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmMessagePart
removeallclassmethods GtLlmMessagePart

doit
(GtLlmMessagePart
	subclass: 'GtLlmFileMessagePart'
	instVarNames: #(fileId file)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFileMessagePart
removeallclassmethods GtLlmFileMessagePart

doit
(GtLlmMessagePart
	subclass: 'GtLlmStringMessagePart'
	instVarNames: #(string)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmStringMessagePart
removeallclassmethods GtLlmStringMessagePart

doit
(Object
	subclass: 'GtLlmMessageSerializer'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmMessageSerializer
removeallclassmethods GtLlmMessageSerializer

doit
(GtLlmMessageSerializer
	subclass: 'GtLlmActionMessageSerializer'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionMessageSerializer
removeallclassmethods GtLlmActionMessageSerializer

doit
(GtLlmActionMessageSerializer
	subclass: 'GtLlmActionMessageWithInstanceSerializer'
	instVarNames: #(instance)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmActionMessageWithInstanceSerializer
removeallclassmethods GtLlmActionMessageWithInstanceSerializer

doit
(Object
	subclass: 'GtLlmModelFile'
	instVarNames: #(directives)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmModelFile
removeallclassmethods GtLlmModelFile

doit
(Object
	subclass: 'GtLlmModelfileDirective'
	instVarNames: #(text)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmModelfileDirective
removeallclassmethods GtLlmModelfileDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmAdapterDirective'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmAdapterDirective
removeallclassmethods GtLlmAdapterDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmFromDirective'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmFromDirective
removeallclassmethods GtLlmFromDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmLicenseDirective'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmLicenseDirective
removeallclassmethods GtLlmLicenseDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmMessageDirective'
	instVarNames: #(messageText)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmMessageDirective
removeallclassmethods GtLlmMessageDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmParameterDirective'
	instVarNames: #(value)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmParameterDirective
removeallclassmethods GtLlmParameterDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmSystemDirective'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmSystemDirective
removeallclassmethods GtLlmSystemDirective

doit
(GtLlmModelfileDirective
	subclass: 'GtLlmTemplateDirective'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmTemplateDirective
removeallclassmethods GtLlmTemplateDirective

doit
(Object
	subclass: 'GtLlmNearestEmbedding'
	instVarNames: #(distance embedding)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNearestEmbedding
removeallclassmethods GtLlmNearestEmbedding

doit
(Object
	subclass: 'GtLlmNewThreadMessage'
	instVarNames: #(assistantChat contents announcer files future isSync)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNewThreadMessage
removeallclassmethods GtLlmNewThreadMessage

doit
(GtLlmNewThreadMessage
	subclass: 'GtLlmNewActionThreadMessage'
	instVarNames: #(currentAction)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNewActionThreadMessage
removeallclassmethods GtLlmNewActionThreadMessage

doit
(Object
	subclass: 'GtLlmNullConnection'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNullConnection
removeallclassmethods GtLlmNullConnection

doit
(Object
	subclass: 'GtLlmPharoObjectSummarizer'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmPharoObjectSummarizer
removeallclassmethods GtLlmPharoObjectSummarizer

doit
(Object
	subclass: 'GtLlmProvider'
	instVarNames: #(chat userMessageClass assistantMessageClass format)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmProvider
removeallclassmethods GtLlmProvider

doit
(GtLlmProvider
	subclass: 'GtLlmNullProvider'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmNullProvider
removeallclassmethods GtLlmNullProvider

doit
(GtLlmNullProvider
	subclass: 'GtLlmStaticProvider'
	instVarNames: #(messages index)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmStaticProvider
removeallclassmethods GtLlmStaticProvider

doit
(GtLlmProvider
	subclass: 'GtOllamaProvider'
	instVarNames: #(assistantWorking model client tools files executions instructions)
	classVars: #(DefaultModel IsConnectable)
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaProvider
removeallclassmethods GtOllamaProvider

doit
(GtLlmProvider
	subclass: 'GtOpenAIProvider'
	instVarNames: #(model client assistantWorking)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIProvider
removeallclassmethods GtOpenAIProvider

doit
(GtOpenAIProvider
	subclass: 'GtOpenAIAssistantProvider'
	instVarNames: #(assistant instructions assistantName assistantDescription tools thread lastRun future files apiFiles)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAssistantProvider
removeallclassmethods GtOpenAIAssistantProvider

doit
(GtOpenAIProvider
	subclass: 'GtOpenAIResponseProvider'
	instVarNames: #(tools instructions executions isStreaming)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIResponseProvider
removeallclassmethods GtOpenAIResponseProvider

doit
(Object
	subclass: 'GtLlmProvisionalThreadMessage'
	instVarNames: #(createdAt chat)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmProvisionalThreadMessage
removeallclassmethods GtLlmProvisionalThreadMessage

doit
(Object
	subclass: 'GtLlmRequestResponse'
	instVarNames: #(request response)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmRequestResponse
removeallclassmethods GtLlmRequestResponse

doit
(Object
	subclass: 'GtLlmToolExamples'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmToolExamples
removeallclassmethods GtLlmToolExamples

doit
(Object
	subclass: 'GtLlmValueHolder'
	instVarNames: #(name announcer chat content)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmValueHolder
removeallclassmethods GtLlmValueHolder

doit
(GtLlmValueHolder
	subclass: 'GtLlmSerializableValueHolder'
	instVarNames: #(serializer updater)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmSerializableValueHolder
removeallclassmethods GtLlmSerializableValueHolder

doit
(GtLlmSerializableValueHolder
	subclass: 'GtLlmCustomSerializationValueHolder'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmCustomSerializationValueHolder
removeallclassmethods GtLlmCustomSerializationValueHolder

doit
(Object
	subclass: 'GtLlmValueSerializer'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmValueSerializer
removeallclassmethods GtLlmValueSerializer

doit
(Object
	subclass: 'GtMcpClient'
	instVarNames: #(messageId stdout serverCapabilities transport)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpClient
removeallclassmethods GtMcpClient

doit
(Object
	subclass: 'GtMcpClientExamples'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpClientExamples
removeallclassmethods GtMcpClientExamples

doit
(Object
	subclass: 'GtMcpPrompt'
	instVarNames: #(name description arguments promptBlock)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpPrompt
removeallclassmethods GtMcpPrompt

doit
(Object
	subclass: 'GtMcpResource'
	instVarNames: #(name title uri mimeType contentsBlock description)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpResource
removeallclassmethods GtMcpResource

doit
(Object
	subclass: 'GtMcpStaticTransport'
	instVarNames: #(index messages)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpStaticTransport
removeallclassmethods GtMcpStaticTransport

doit
(Object
	subclass: 'GtMcpStdioTransport'
	instVarNames: #(process stdout messages)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtMcpStdioTransport
removeallclassmethods GtMcpStdioTransport

doit
(Object
	subclass: 'GtOllamaClient'
	instVarNames: #(baseUrl history)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Ollama';
		immediateInvariant.
true.
%

removeallmethods GtOllamaClient
removeallclassmethods GtOllamaClient

doit
(Object
	subclass: 'GtOpenAIClient'
	instVarNames: #(baseUrl apiKey history)
	classVars: #(ApiKeyFile)
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIClient
removeallclassmethods GtOpenAIClient

doit
(Object
	subclass: 'GtOpenAIGroup'
	instVarNames: #(client items)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIGroup
removeallclassmethods GtOpenAIGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIAnnotationsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAnnotationsGroup
removeallclassmethods GtOpenAIAnnotationsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIAssistantChatGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAssistantChatGroup
removeallclassmethods GtOpenAIAssistantChatGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIAssistantsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIAssistantsGroup
removeallclassmethods GtOpenAIAssistantsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIEmbeddingsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIEmbeddingsGroup
removeallclassmethods GtOpenAIEmbeddingsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIFilesGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFilesGroup
removeallclassmethods GtOpenAIFilesGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIFineTuningCheckpointsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFineTuningCheckpointsGroup
removeallclassmethods GtOpenAIFineTuningCheckpointsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIFineTuningEventsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIFineTuningEventsGroup
removeallclassmethods GtOpenAIFineTuningEventsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIMessagesGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIMessagesGroup
removeallclassmethods GtOpenAIMessagesGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIModelsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIModelsGroup
removeallclassmethods GtOpenAIModelsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIStepsGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIStepsGroup
removeallclassmethods GtOpenAIStepsGroup

doit
(GtOpenAIGroup
	subclass: 'GtOpenAIVectorStoresGroup'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIVectorStoresGroup
removeallclassmethods GtOpenAIVectorStoresGroup

doit
(Object
	subclass: 'GtOpenAIRawToolMessage'
	instVarNames: #(rawData chat createdAt toolCall reasoning)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIRawToolMessage
removeallclassmethods GtOpenAIRawToolMessage

doit
(Object
	subclass: 'GtOpenAIResourceFile'
	instVarNames: #(file description remoteId)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIResourceFile
removeallclassmethods GtOpenAIResourceFile

doit
(Object
	subclass: 'GtOpenAIUtilities'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4OpenAI';
		immediateInvariant.
true.
%

removeallmethods GtOpenAIUtilities
removeallclassmethods GtOpenAIUtilities

doit
(Object
	subclass: 'GtPretrainedEncoder'
	instVarNames: #(merges reversedMerges)
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtPretrainedEncoder
removeallclassmethods GtPretrainedEncoder

doit
(OrderedCollection
	subclass: 'GtLlmRequestHistory'
	instVarNames: #()
	classVars: #()
	classInstVars: #()
	poolDictionaries: #()
	inDictionary: Globals
	options: #( #logCreation )
)
		category: 'Gt4Llm';
		immediateInvariant.
true.
%

removeallmethods GtLlmRequestHistory
removeallclassmethods GtLlmRequestHistory

! Class implementation for 'GtLlmActionCall'

!		Class methods for 'GtLlmActionCall'

category: 'accessing'
classmethod: GtLlmActionCall
action: aString
	^ self new action: aString
%

category: 'accessing'
classmethod: GtLlmActionCall
action: aString arguments: aListOfStrings
	^ self new
		action: aString;
		arguments: aListOfStrings
%

!		Instance methods for 'GtLlmActionCall'

category: 'accessing'
method: GtLlmActionCall
action
	^ action
%

category: 'accessing'
method: GtLlmActionCall
action: anObject
	action := anObject
%

category: 'accessing'
method: GtLlmActionCall
arguments
	^ arguments
%

category: 'accessing'
method: GtLlmActionCall
arguments: anObject
	arguments := anObject
%

category: 'views'
method: GtLlmActionCall
gtSerializedFor: aView
	<gtView>
	^ aView forward
		title: 'Serialized';
		object: [ self serialize ];
		view: #gtJSONFor:
%

category: 'views'
method: GtLlmActionCall
gtSerializedJSONFor: aView
	<gtView>
	^ aView forward
		title: 'JSON';
		object: [ self serialize ];
		view: #gtJSONDataFor:context:
%

category: 'as yet unclassified'
method: GtLlmActionCall
initialize
	arguments := {}
%

category: 'as yet unclassified'
method: GtLlmActionCall
serialize
	| toSerialize |
	toSerialize := {'Action' -> action.
			'Arguments' -> (arguments collect: #asString)}.
	subject ifNotNil: [ toSerialize := toSerialize, subject serialize asOrderedCollection ].
	^ STONJSON toString: toSerialize asDictionary
%

category: 'accessing'
method: GtLlmActionCall
subject
	"this is an optional object that we might want to serialize"
	^ subject
%

category: 'accessing'
method: GtLlmActionCall
subject: anObject
	subject := anObject
%

! Class implementation for 'GtLlmNewThreadMessageContentsChanged'

!		Instance methods for 'GtLlmNewThreadMessageContentsChanged'

category: 'accessing'
method: GtLlmNewThreadMessageContentsChanged
contents
	^ contents
%

category: 'accessing'
method: GtLlmNewThreadMessageContentsChanged
contents: anObject
	contents := anObject
%

category: 'accessing'
method: GtLlmNewThreadMessageContentsChanged
requester
	^ requester
%

category: 'accessing'
method: GtLlmNewThreadMessageContentsChanged
requester: anObject
	requester := anObject
%

category: 'accessing'
method: GtLlmNewThreadMessageContentsChanged
threadMessage
	^ threadMessage
%

category: 'accessing'
method: GtLlmNewThreadMessageContentsChanged
threadMessage: anObject
	threadMessage := anObject
%

! Class implementation for 'GtSharedStringUpdated'

!		Instance methods for 'GtSharedStringUpdated'

category: 'accessing'
method: GtSharedStringUpdated
string
	^ string
%

category: 'accessing'
method: GtSharedStringUpdated
string: anObject
	string := anObject
%

! Class implementation for 'GtLlmError'

!		Class methods for 'GtLlmError'

category: 'instance creation'
classmethod: GtLlmError
from: aMessage
	^ self new messageText: aMessage
%

!		Instance methods for 'GtLlmError'

category: 'views'
method: GtLlmError
gtMessageTextFor: aView
	<gtView>
	<gtExceptionDebuggingView>
	^ super gtMessageTextFor: aView
%

! Class implementation for 'GtOpenAIError'

!		Class methods for 'GtOpenAIError'

category: 'accessing'
classmethod: GtOpenAIError
from: aDictionary
	^ self new
		messageText: (aDictionary at: 'message');
		type: (aDictionary at: 'type');
		param: (aDictionary at: 'param');
		code: (aDictionary at: 'code')
%

!		Instance methods for 'GtOpenAIError'

category: 'accessing'
method: GtOpenAIError
code
	^ code
%

category: 'accessing'
method: GtOpenAIError
code: anObject
	code := anObject
%

category: 'accessing'
method: GtOpenAIError
param
	^ param
%

category: 'accessing'
method: GtOpenAIError
param: anObject
	param := anObject
%

category: 'accessing'
method: GtOpenAIError
type
	^ type
%

category: 'accessing'
method: GtOpenAIError
type: anObject
	type := anObject
%

! Class implementation for 'GtBPEEncoder'

!		Instance methods for 'GtBPEEncoder'

category: 'accessing'
method: GtBPEEncoder
defaultVocabularySize
	^ 286
%

category: 'accessing'
method: GtBPEEncoder
encode: aString
	| tokens stats mergeResult |
	tokens := self tokenize: aString.
	stats := self getStatsFor: tokens.
	mergeResult := self mergeTokens: tokens withVocabularySize: self vocabularySize.
	^ GtBPEEncodingResult new
		input: aString;
		tokens: tokens;
		stats: stats;
		merges: mergeResult merges;
		output: mergeResult output
%

category: 'accessing'
method: GtBPEEncoder
initialize
	super initialize.
	
	vocabularySize := self defaultVocabularySize
%

category: 'accessing'
method: GtBPEEncoder
mergePair: aPair into: anId inTokens: tokens
	| result anIndex |
	result := OrderedCollection new.
	anIndex := 1.
	[ anIndex <= tokens size ]
		whileTrue: [ (anIndex < (tokens size - 1)
				and: [ aPair
						= {tokens at: anIndex.
								tokens at: anIndex + 1} ])
				ifTrue: [ result add: anId.
					anIndex := anIndex + 2 ]
				ifFalse: [ result add: (tokens at: anIndex).
					anIndex := anIndex + 1 ] ].
	^ result
%

category: 'accessing'
method: GtBPEEncoder
mergeTokens: aListOfTokens withVocabularySize: anInteger
	| numberOfMerges aResult merges |
	numberOfMerges := anInteger - 256.
	aResult := aListOfTokens.
	merges := Dictionary new.
	1
		to: numberOfMerges
		do: [ :anIndex | 
			| currentStats pair newId |
			currentStats := self getStatsFor: aResult.
			pair := currentStats mostFrequent.
			newId := 256 + anIndex.
			aResult := self
					mergePair: pair
					into: newId
					inTokens: aResult.
			merges at: pair put: newId ].
	^ GtBPEMergeResult new merges: merges; output: aResult
%

category: 'accessing'
method: GtBPEEncoder
tokenize: aString 
	^ aString asUTF8Bytes
%

category: 'accessing'
method: GtBPEEncoder
vocabularySize
	^ vocabularySize
%

category: 'accessing'
method: GtBPEEncoder
vocabularySize: anObject
	vocabularySize := anObject
%

! Class implementation for 'GtBPEEncoderExamples'

!		Instance methods for 'GtBPEEncoderExamples'

category: 'as yet unclassified'
method: GtBPEEncoderExamples
bpeEncoderWithMergedTokens
	<gtExample>
	| encoder tokens result |
	encoder := GtBPEEncoder new.
	tokens := encoder tokenize: 'aaaa'.
	result := encoder mergeTokens: tokens withVocabularySize: 258.
	self assert: (result merges at: #(97 97)) equals: 257.
	self assert: (result merges at: #(257 97)) equals: 258.
	self assert: result output size equals: 2.
	self assert: result output equals: #(258 97) asOrderedCollection.
	^ encoder
%

category: 'accessing'
method: GtBPEEncoderExamples
encodedLorem
	<gtExample>
	| encoder encoded |
	encoder := GtBPEEncoder new.
	encoded := encoder encode: String loremIpsum.
	
	self assert: encoded output size equals: 300.
	self assert: encoded compressionRatio > 1.
	
	^ encoded
%

category: 'accessing'
method: GtBPEEncoderExamples
preTrainedEncoderLorem
	<gtExample>
	| encoder encoded |
	encoder := GtPretrainedEncoder new merges: self encodedLorem merges.
	encoded := encoder encode: String loremIpsum.
	
	self assert: encoded size equals: 300.
	self assert: (encoder decode: encoded) equals: String loremIpsum.
	
	^ encoded
%

! Class implementation for 'GtBPEEncodingResult'

!		Instance methods for 'GtBPEEncodingResult'

category: 'accessing'
method: GtBPEEncodingResult
compressionRatio
	self output size = 0 ifTrue: [ ^ self tokens size ].
	^ self tokens size / self output size
%

category: 'accessing'
method: GtBPEEncodingResult
gtCompressionRatioFor: aView
	<gtView>
	^ aView forward
		title: 'Compression ratio';
		priority: 5;
		object: [ self compressionRatio ];
		view: #gtLiveFor:
%

category: 'accessing'
method: GtBPEEncodingResult
gtInputFor: aView
	<gtView>
	^ aView textEditor
		title: 'Input';
		priority: 2;
		text: [ self input ]
%

category: 'accessing'
method: GtBPEEncodingResult
gtInputTokensFor: aView
	<gtView>
	^ aView forward
		title: 'Input tokens';
		priority: 3;
		object: [ self tokens ];
		view: #gtLiveFor:
%

category: 'accessing'
method: GtBPEEncodingResult
gtMergesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Merges';
		priority: 4;
		items: [ self merges associations ];
		column: 'Input pair' text: [ :aPair | ', ' join: aPair key ];
		column: 'Output token' text: #value
%

category: 'accessing'
method: GtBPEEncodingResult
gtOutputFor: aView
	<gtView>
	^ aView forward
		title: 'Output';
		priority: 1;
		object: [ self output ];
		view: #gtLiveFor:
%

category: 'accessing'
method: GtBPEEncodingResult
input
	^ input
%

category: 'accessing'
method: GtBPEEncodingResult
input: anObject
	input := anObject
%

category: 'accessing'
method: GtBPEEncodingResult
merges
	^ merges
%

category: 'accessing'
method: GtBPEEncodingResult
merges: anObject
	merges := anObject
%

category: 'accessing'
method: GtBPEEncodingResult
output
	^ output
%

category: 'accessing'
method: GtBPEEncodingResult
output: anObject
	output := anObject
%

category: 'accessing'
method: GtBPEEncodingResult
stats
	^ stats
%

category: 'accessing'
method: GtBPEEncodingResult
stats: anObject
	stats := anObject
%

category: 'accessing'
method: GtBPEEncodingResult
tokens
	^ tokens
%

category: 'accessing'
method: GtBPEEncodingResult
tokens: anObject
	tokens := anObject
%

! Class implementation for 'GtBPEMergeResult'

!		Instance methods for 'GtBPEMergeResult'

category: 'accessing'
method: GtBPEMergeResult
merges
	^ merges
%

category: 'accessing'
method: GtBPEMergeResult
merges: anObject
	merges := anObject
%

category: 'accessing'
method: GtBPEMergeResult
output
	^ output
%

category: 'accessing'
method: GtBPEMergeResult
output: anObject
	output := anObject
%

! Class implementation for 'GtLlmActionCallExamples'

!		Instance methods for 'GtLlmActionCallExamples'

category: 'as yet unclassified'
method: GtLlmActionCallExamples
actionCall
	<gtExample>
	| actionCall serialized unserialized |
	actionCall := GtLlmActionCall new.
	serialized := actionCall serialize.
	self assert: serialized isString.
	unserialized := STONJSON fromString: serialized.
	self assert: unserialized isDictionary.
	self assert: unserialized size equals: 2.
	self assert: (unserialized at: 'Action') isNil.
	self assert: (unserialized at: 'Arguments') isEmpty.
	^ actionCall
%

category: 'as yet unclassified'
method: GtLlmActionCallExamples
actionCallWithName
	<gtExample>
	| actionCall serialized unserialized |
	actionCall := self actionCall.
	actionCall action: 'Some action name'.
	serialized := actionCall serialize.
	self assert: serialized isString.
	unserialized := STONJSON fromString: serialized.
	self assert: unserialized isDictionary.
	self assert: unserialized size equals: 2.
	self assert: (unserialized at: 'Action') equals: 'Some action name'.
	self assert: (unserialized at: 'Arguments') isEmpty.
	^ actionCall
%

category: 'as yet unclassified'
method: GtLlmActionCallExamples
actionCallWithNameAndArguments
	<gtExample>
	| actionCall serialized unserialized |
	actionCall := self actionCallWithName.
	actionCall arguments: {'Arg1' . 'Arg2'}.
	serialized := actionCall serialize.
	self assert: serialized isString.
	unserialized := STONJSON fromString: serialized.
	self assert: unserialized isDictionary.
	self assert: unserialized size equals: 2.
	self assert: (unserialized at: 'Action') equals: 'Some action name'.
	self assert: (unserialized at: 'Arguments') size equals: 2.
	self assert: (unserialized at: 'Arguments') first equals: 'Arg1'.
	self assert: (unserialized at: 'Arguments') last equals: 'Arg2'.
	^ actionCall
%

! Class implementation for 'GtLlmActionReference'

!		Instance methods for 'GtLlmActionReference'

category: 'accessing'
method: GtLlmActionReference
action
	^ action
%

category: 'accessing'
method: GtLlmActionReference
action: anObject
	action := anObject
%

category: 'accessing'
method: GtLlmActionReference
initialize
	super initialize.
	
	isInput := false.
	isOutput := false
%

category: 'accessing'
method: GtLlmActionReference
isInput
	^ isInput
%

category: 'accessing'
method: GtLlmActionReference
isOutput
	^ isOutput
%

category: 'accessing'
method: GtLlmActionReference
markInput
	isInput := true
%

category: 'accessing'
method: GtLlmActionReference
markOutput
	isOutput := true
%

! Class implementation for 'GtLlmAssistant'

!		Class methods for 'GtLlmAssistant'

category: 'other'
classmethod: GtLlmAssistant
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmAssistant'

category: 'as yet unclassified'
method: GtLlmAssistant
actionFormatDescription
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new beRequired
		name: 'Action';
		format: 'Text';
		example: '```text
Create a draft
```'
%

category: 'as yet unclassified'
method: GtLlmAssistant
actionNamed: anActionName
	^ self instruction actionNamed: anActionName
%

category: 'accessing'
method: GtLlmAssistant
actions
	^ instruction actions
%

category: 'as yet unclassified'
method: GtLlmAssistant
addAction: anAction
	instruction addAction: (anAction assistant: self)
%

category: 'as yet unclassified'
method: GtLlmAssistant
addFormat: aComponent
	instruction addComponent: aComponent
%

category: 'as yet unclassified'
method: GtLlmAssistant
addInstructionSection: aSection
	instruction addSection: aSection
%

category: 'as yet unclassified'
method: GtLlmAssistant
argumentsFormatDescription
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Arguments';
		format: 'Array of text';
		type: {'array'. 'null'};
		items: {'type' -> 'string'} asDictionary;
		example: '{"Argument 1", "Argument 2"}'
%

category: 'as yet unclassified'
method: GtLlmAssistant
buildProvider
	^ connection buildProvider
%

category: 'as yet unclassified'
method: GtLlmAssistant
chatAction
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Chat';
		priority: 1;
		description: 'Chat using the text field.';
		addArgument: 'Message';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Chat'.
							'Arguments' -> {'Hi! How are you?'}} asDictionary;
					output: {'Action' -> 'Chat'.
							'Arguments' -> {'Hi! How are you?'}.
							'Text'
								-> 'As an AI model, I do not have feelings. How can I assist you today?'}
							asDictionary}
%

category: 'as yet unclassified'
method: GtLlmAssistant
collectActions
	^ (((Set
		withAll: ((Pragma
				allNamed: #gtLlmAssistantAction
				from: self class
				to: Object) collect: [ :aPragma | aPragma methodSelector ])) asSet
		collect: [ :aSelector | self perform: aSelector ]
		thenSelect: [ :anAction | anAction isNotNil ])
		collect: [ :anAction | anAction assistant: self ])
		sorted: [ :a :b | a priority < b priority ]
%

category: 'as yet unclassified'
method: GtLlmAssistant
collectFormats
	^ (((Pragma
		allNamed: #gtLlmAssistantFormat
		from: self class
		to: Object) collect: [ :aPragma | aPragma methodSelector ]) asSet
		collect: [ :aSelector | (self perform: aSelector) assistant: self ])
		sorted: [ :a :b | a priority < b priority ]
%

category: 'as yet unclassified'
method: GtLlmAssistant
collectSections
	^ (Pragma
		allNamed: #gtLlmInstructionSection
		from: self class
		to: Object) collect: [ :aPragma | self perform: aPragma methodSelector ]
%

category: 'as yet unclassified'
method: GtLlmAssistant
collectTools
	^ GtLlmToolsGroup
		withAll: ((Set
				withAll: ((Pragma
						allNamed: #gtLlmTool
						from: self class
						to: Object) collect: [ :aPragma | aPragma methodSelector ])) asSet
				collect: [ :aSelector | self perform: aSelector ]
				thenSelect: [ :aTool | aTool isNotNil ]) asOrderedCollection
%

category: 'accessing'
method: GtLlmAssistant
connection
	^ connection
%

category: 'accessing'
method: GtLlmAssistant
connection: anObject
	connection := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistant
createChat
	^ self createChatWithProvider: self buildProvider
%

category: 'as yet unclassified'
method: GtLlmAssistant
createChatWithProvider: provider
	^ GtLlmActionChat new
		assistant: self;
		provider: provider
%

category: 'as yet unclassified'
method: GtLlmAssistant
defaultDescription
	^ 'You are an assistant.'
%

category: 'as yet unclassified'
method: GtLlmAssistant
description
	^ self instruction description
%

category: 'accessing'
method: GtLlmAssistant
description: anObject
	instruction description: anObject
%

category: 'as yet unclassified'
method: GtLlmAssistant
formatComponents
	^ instruction formats
%

category: 'as yet unclassified'
method: GtLlmAssistant
formatNamed: aString
	^ instruction componentNamed: aString
%

category: 'as yet unclassified'
method: GtLlmAssistant
gtInstructionFor: aView
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 9;
		object: [ instruction asInstructionPiece ];
		view: #gtInstructionFor:
%

category: 'as yet unclassified'
method: GtLlmAssistant
initialize
	super initialize.

	self initializeInstruction.

	self connection: GtLlmConnectionRegistry uniqueInstance defaultConnection.

	self description: self defaultDescription
%

category: 'as yet unclassified'
method: GtLlmAssistant
initializeInstruction
	instruction := GtLlmAssistantInstruction new.
	instruction
		addComponents: self collectFormats;
		addActions: self collectActions;
		addSections: self collectSections
%

category: 'accessing'
method: GtLlmAssistant
instruction
	^ instruction
%

category: 'as yet unclassified'
method: GtLlmAssistant
recomputeActions
	instruction replaceActions: self collectActions
%

category: 'as yet unclassified'
method: GtLlmAssistant
recomputeFormats
	instruction replaceComponents: self collectFormats
%

category: 'as yet unclassified'
method: GtLlmAssistant
textFormatDescription
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
		name: 'Text';
		priority: 2;
		format: 'Text';
		example: '```text
This node contains plain text.
Multiple lines, multiple paragraphs are allowed.

*markup* may also **be used**. `Code` can be highlighted,  and code sections using three backticks may be used.

# Headings exist as well
```'
%

category: 'as yet unclassified'
method: GtLlmAssistant
treatProvider: aProvider
	aProvider 
		instructions: instruction asInstructionPiece instructionString;
		format: instruction asJsonSchema;
		tools: self collectTools
%

! Class implementation for 'GtLlmTutor'

!		Class methods for 'GtLlmTutor'

category: 'testing'
classmethod: GtLlmTutor
isDeprecated
	^ true
%

! Class implementation for 'GtOpenAIBlogPostAssistant'

!		Instance methods for 'GtOpenAIBlogPostAssistant'

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
createChatOn: aText
	| chat |
	chat := self createChat.
	chat onInstance: (self valueHolderFor: aText).
	^ chat
%

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
defaultDescription
	^ 'You are an assistant that is used to interactively work on blog posts. You trigger certain actions to generate a desired result.'
%

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
gtCorrectGrammar
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Correct grammar';
		priority: 10;
		description: 'Correct grammar. Place the result in the `Post` property.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Correct grammar'.
							'Arguments' -> {}.
							'Post'
								-> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. There are a number of recent article proposes mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs are generators of possibilities that should be evaluated against reality before being relied upon for decision making in a technical space.

That is why I favor (B) especially when combined with a moldable development environment. When we get the tools we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). Moldable Development splits technical decision making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target LLMs.

Oh yes, I know, agents can add include feedback when generating solutions. But even then, there is no reason to not expose biases. In a technical space we can nicely produce the tools we can use without intermediaries against the system.'}
							asDictionary;
					output: {'Action' -> 'Correct grammar'.
							'Text' -> nil.
							'Arguments' -> nil.
							'Post'
								-> 'There are at least two ways to use LLMs for supporting the understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. A number of recent articles propose mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs as generators of possibilities that should be evaluated against reality before being relied upon for decision-making in a technical space.

That is why I favor (B), especially when combined with a moldable development environment. When we get the tools, we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). Moldable Development splits technical decision-making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target for LLMs.

Oh yes, I know, agents can include feedback when generating solutions. But even then, there is no reason not to expose biases. In a technical space, we can nicely produce the tools we can use without intermediaries against the system.'}
							asDictionary}
%

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
gtCreateTitle
	<gtLlmAssistantAction>
	^ GtLlmAssistantAction new
		name: 'Create title';
		priority: 10;
		description: 'Create title. Put result in the `Text` property. Do not use quotes of any kind. Be crisp.';
		examples: {GtLlmAssistantActionExample new
					input: {'Action' -> 'Create Title'.
							'Arguments' -> nil.
							'Post'
								-> 'There are at least two ways to use LLMs for supporting understanding of software systems:
(A) use LLMs to generate summaries
(B) use LLMs to generate tools with which you generate summaries

The difference might appear subtle, but it''s significant. There are a number of recent article proposes mostly (A) as a direction. These use LLMs as solution generators.

However, any concrete solutions entail biases. When we get the final answer, these biases are invisible. The solution might be correct, but you''d have no real way of knowing what tradeoffs they contain. The alternative is to regard current LLMs are generators of possibilities that should be evaluated against reality before being relied upon for decision making in a technical space.

That is why I favor (B) especially when combined with a moldable development environment. When we get the tools we have a chance to review the bias and apply other forms of checks, too. We can then use these tools to produce visualizations of the system ourselves.

LLMs work interestingly well for shallow questions (I call shallow the questions whose answers can be evaluated against reality quickly). Moldable Development splits technical decision making into small shallow problems addressed by small shallow tools. As such, it can be a fertile target LLMs.

Oh yes, I know, agents can add include feedback when generating solutions. But even then, there is no reason to not expose biases. In a technical space we can nicely produce the tools we can use without intermediaries against the system.'}
							asDictionary;
					output: {'Action' -> 'Create Title'.
							'Arguments' -> nil.
							'Text' -> 'Leveraging LLMs for Informed Software Understanding'.
							'Post' -> nil} asDictionary}
%

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
gtPostFormatDescription
	<gtLlmAssistantFormat>
	^ GtLlmAssistantFormatDescription new
	type: ((OrderedCollection new) add: 'string'; add: 'null'; yourself);
	format: 'Text';
	name: 'Post';
	priority: 10;
	example: ''
%

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
treatProvider: aProvider
	super treatProvider: aProvider.

	aProvider
		assistantMessageClass: GtOpenAIBlogPostMessage;
		userMessageClass: GtOpenAIBlogPostMessage
%

category: 'as yet unclassified'
method: GtOpenAIBlogPostAssistant
valueHolderFor: anObject
	^ GtLlmSerializableValueHolder new
		name: 'Post';
		content: anObject;
		serializer: #asString;
		updater: [ :aText :aString | 
			aText deleteAll
				appendString: aString;
				yourself ]
%

! Class implementation for 'GtLlmAssistantAction'

!		Class methods for 'GtLlmAssistantAction'

category: 'other'
classmethod: GtLlmAssistantAction
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmAssistantAction'

category: 'as yet unclassified'
method: GtLlmAssistantAction
addArgument: anArgument
	arguments add: anArgument
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
addExample: anExample
	examples add: (anExample action: self)
%

category: 'accessing'
method: GtLlmAssistantAction
arguments
	^ arguments
%

category: 'accessing'
method: GtLlmAssistantAction
arguments: anObject
	arguments := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
asExpressionSource
	^ self class name asString
		, ' new
	    name: ' , self name storeString
		, ';
	    priority: ' , self priority asString
		, ';
		description: ' , self description storeString
		, (self arguments
				collect: [ :anArgument | 
					';
		addArgument: ''' , anArgument , '''' ])
		, ';
		examples: {'
		, ('.
			' join: (self examples collect: #asExpressionSource)) , '}'
%

category: 'accessing'
method: GtLlmAssistantAction
asInstructionPiece
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmInstructionComposite new
				addItem: self description;
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Examples';
						body: (GtLlmInstructionComposite new items: self examples)))
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
asMethodSource
	| methodSource |
	methodSource := (self definingMethod
			ifNil: [ 'gtNAMEAction' ]
			ifNotNil: [ :aMethod | aMethod selector asString ])
			, '
	<gtLlmAssistantAction>
	^ ' , self asExpressionSource.
	^ methodSource
%

category: 'accessing'
method: GtLlmAssistantAction
assistant
	^ assistant
%

category: 'accessing'
method: GtLlmAssistantAction
assistant: anObject
	assistant := anObject.
	
	self onAssistantChanged
%

category: 'accessing'
method: GtLlmAssistantAction
defaultPriority
	^ 10
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
definingMethod
	^ definingMethod
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
definingMethod: aMethod
	definingMethod := nil
%

category: 'accessing'
method: GtLlmAssistantAction
description
	^ description
%

category: 'accessing'
method: GtLlmAssistantAction
description: anObject
	description := anObject
%

category: 'accessing'
method: GtLlmAssistantAction
examples
	^ examples
%

category: 'accessing'
method: GtLlmAssistantAction
examples: anObject
	examples := anObject asOrderedCollection.

	examples do: [ :anExample | anExample action: self ]
%

category: 'accessing'
method: GtLlmAssistantAction
formatReferences
	^ (self examples flatCollect: #formatReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
%

category: 'accessing'
method: GtLlmAssistantAction
gtDescriptionFor: aView
	<gtView>
	^ aView textEditor
		title: 'Description';
		text: [ self description ]
%

category: 'accessing'
method: GtLlmAssistantAction
gtExamplesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Examples';
		items: [ self examples ];
		column: 'Input' text: #inputJson;
		column: 'Output' text: #outputJson
%

category: 'accessing'
method: GtLlmAssistantAction
gtInputFormatReferencesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
%

category: 'accessing'
method: GtLlmAssistantAction
gtInstructionFor: aView
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 2;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
%

category: 'accessing'
method: GtLlmAssistantAction
gtOutputFormatReferencesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
hasArgument
	^ arguments isNotEmpty
%

category: 'accessing'
method: GtLlmAssistantAction
initialize
	super initialize.

	self priority: self defaultPriority.
	self examples: OrderedCollection new.
	self arguments: OrderedCollection new.
	self name: ''.
	self description: ''.

	definingMethod := self initializeMethod
%

category: 'accessing'
method: GtLlmAssistantAction
inputReferences
	^ (self examples flatCollect: #inputReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
%

category: 'accessing'
method: GtLlmAssistantAction
name
	^ name
%

category: 'accessing'
method: GtLlmAssistantAction
name: anObject
	name := anObject
%

category: 'accessing'
method: GtLlmAssistantAction
onAssistantChanged
	self examples do: [ :anExample | anExample verify resolveReferences ]
%

category: 'accessing'
method: GtLlmAssistantAction
outputReferences
	^ (self examples flatCollect: #outputReferences as: Set)
		sorted: [ :a :b | a priority < b priority ]
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
persist
	| methodSource |
	methodSource := self asMethodSource.

	"TODO: RBConfigurableFormatter and RBParser are defined as part of Rowan.
	It needs to be exported to .gs to be usable in GemStone"
	self definingMethod methodClass
		compile: (#RBConfigurableFormatter asClass format: (#RBParser asClass parseMethod: methodSource)).
	definingMethod := self definingMethod methodClass
			>> self definingMethod selector
%

category: 'accessing'
method: GtLlmAssistantAction
pipeline
	^ pipeline
%

category: 'accessing'
method: GtLlmAssistantAction
pipeline: anObject
	pipeline := anObject
%

category: 'accessing'
method: GtLlmAssistantAction
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
%

category: 'accessing'
method: GtLlmAssistantAction
priority
	^ priority
%

category: 'accessing'
method: GtLlmAssistantAction
priority: anObject
	priority := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantAction
removeFromSystem
	self definingMethod ifNotNil: [ :aMethod | aMethod removeFromSystem ]
%

! Class implementation for 'GtLlmAssistantActionExample'

!		Class methods for 'GtLlmAssistantActionExample'

category: 'instance creation'
classmethod: GtLlmAssistantActionExample
new
	"Answer an initalised instance of the receiver.
	For GemStone compatibility."

	^ self basicNew initialize.
%

!		Instance methods for 'GtLlmAssistantActionExample'

category: 'accessing'
method: GtLlmAssistantActionExample
action
	^ action
%

category: 'accessing'
method: GtLlmAssistantActionExample
action: anObject
	action := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantActionExample
asExpressionSource
	^ self class name asString
		, ' new
	input: { '
		, ('. '
				join: (self input associations
						collect: [ :aPair | 
							'''' , aPair key , ''' -> '
								, (aPair value ifNil: [ 'nil' ] ifNotNil: [ :aValue | aValue storeString ]) ]))
		, ' } asDictionary;
	output: { '
		, ('. '
				join: (self output associations
						collect: [ :aPair | 
							'''' , aPair key , ''' -> '
								, (aPair value ifNil: [ 'nil' ] ifNotNil:[ :aValue | aValue storeString ]) ]))
		, ' } asDictionary'
%

category: 'accessing'
method: GtLlmAssistantActionExample
asInstructionPiece
	^ GtLlmInstructionList new
		source: self;
		addItem: ('Prompt:
```json
' , self inputJson
				, '
```') asInstructionPiece;
		addItem: ('Output:
```json
' , self outputJson
				, '
```') asInstructionPiece
%

category: 'accessing'
method: GtLlmAssistantActionExample
formatReferences
	^ inputReferences, outputReferences
%

category: 'accessing'
method: GtLlmAssistantActionExample
gtInputFormatReferencesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Input format references';
		priority: 5;
		items: [ self inputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
%

category: 'accessing'
method: GtLlmAssistantActionExample
gtInstructionFor: aView
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
%

category: 'accessing'
method: GtLlmAssistantActionExample
gtOutputFormatReferencesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Output format references';
		priority: 6;
		items: [ self outputReferences ];
		column: 'Name' text: #name;
		column: 'Format' text: #format
%

category: 'accessing'
method: GtLlmAssistantActionExample
initialize
	super initialize.
	
	inputReferences := OrderedCollection new.
	outputReferences := OrderedCollection new.
	self markVerified
%

category: 'accessing'
method: GtLlmAssistantActionExample
input
	^ input
%

category: 'accessing'
method: GtLlmAssistantActionExample
input: anObject
	input := anObject
%

category: 'accessing'
method: GtLlmAssistantActionExample
inputJson
	^ STONJSON toStringPretty: self input
%

category: 'accessing'
method: GtLlmAssistantActionExample
inputJson: aJson
	^ self input: (STONJSON fromString: aJson)
%

category: 'accessing'
method: GtLlmAssistantActionExample
inputReferences
	^ inputReferences
%

category: 'accessing'
method: GtLlmAssistantActionExample
inputReferences: anObject
	inputReferences := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantActionExample
markUnverified
	unverified := true
%

category: 'as yet unclassified'
method: GtLlmAssistantActionExample
markVerified
	unverified := false
%

category: 'accessing'
method: GtLlmAssistantActionExample
output
	^ output
%

category: 'accessing'
method: GtLlmAssistantActionExample
output: anObject
	output := anObject
%

category: 'accessing'
method: GtLlmAssistantActionExample
outputJson
	^ STONJSON toStringPretty: self output
%

category: 'accessing'
method: GtLlmAssistantActionExample
outputJson: aJson
	^ self output: (STONJSON fromString: aJson)
%

category: 'accessing'
method: GtLlmAssistantActionExample
outputReferences
	^ outputReferences
%

category: 'accessing'
method: GtLlmAssistantActionExample
outputReferences: anObject
	outputReferences := anObject
%

category: 'accessing'
method: GtLlmAssistantActionExample
resolveReferences
	inputReferences := input associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action assistant formatNamed: anAssociation key)
					addInputReference: self action ].
	outputReferences := output associations
			select: [ :anAssociation | anAssociation value isNotNil ]
			thenCollect: [ :anAssociation | 
				(self action assistant formatNamed: anAssociation key)
					addOutputReference: self action ]
%

category: 'accessing'
method: GtLlmAssistantActionExample
unverified
	^ unverified
%

category: 'accessing'
method: GtLlmAssistantActionExample
unverified: anObject
	unverified := anObject
%

category: 'accessing'
method: GtLlmAssistantActionExample
verify
	unverified ifTrue: [ ^ self ].
	self
		assert: self output keys asSet
				= (self action assistant formatComponents collect: #name) asSet
		description: 'Keys in the example output must correspond to the action format'
%

! Class implementation for 'GtLlmAssistantChatStatus'

!		Class methods for 'GtLlmAssistantChatStatus'

category: 'factory'
classmethod: GtLlmAssistantChatStatus
forAssistantChat: anAssistantChat
	 
%

category: 'factory'
classmethod: GtLlmAssistantChatStatus
forLastRun: aGtOpenAIThreadRun
	aGtOpenAIThreadRun ifNil: [ ^ GtLlmAssistantChatReadyStatus new ].
	^ GtLlmAssistantChatDynamicStatus new threadRun: aGtOpenAIThreadRun
%

!		Instance methods for 'GtLlmAssistantChatStatus'

category: 'accessing'
method: GtLlmAssistantChatStatus
completedAt
	<return: #DateAndTime or: nil>
	^ self subclassResponsibility
%

category: 'accessing'
method: GtLlmAssistantChatStatus
createdAt
	<return: #DateAndTime>
	^ self subclassResponsibility
%

category: 'testing'
method: GtLlmAssistantChatStatus
isDone
	^ self subclassResponsibility
%

category: 'testing'
method: GtLlmAssistantChatStatus
isFailed
	^ self subclassResponsibility
%

! Class implementation for 'GtLlmAssistantChatDynamicStatus'

!		Instance methods for 'GtLlmAssistantChatDynamicStatus'

category: 'accessing'
method: GtLlmAssistantChatDynamicStatus
completedAt
	^ threadRun completedAt
%

category: 'accessing'
method: GtLlmAssistantChatDynamicStatus
createdAt
	^ threadRun createdAt
%

category: 'printing'
method: GtLlmAssistantChatDynamicStatus
gtDisplayOn: stream
	stream nextPutAll: threadRun status
%

category: 'testing'
method: GtLlmAssistantChatDynamicStatus
isDone
	^ threadRun isDone
%

category: 'testing'
method: GtLlmAssistantChatDynamicStatus
isFailed
	^ threadRun isFailed
%

category: 'accessing'
method: GtLlmAssistantChatDynamicStatus
message
	^ threadRun failureMessage
%

category: 'accessing'
method: GtLlmAssistantChatDynamicStatus
threadRun
	^ threadRun
%

category: 'accessing'
method: GtLlmAssistantChatDynamicStatus
threadRun: anObject
	threadRun := anObject
%

! Class implementation for 'GtLlmAssistantChatNotReadyStatus'

!		Instance methods for 'GtLlmAssistantChatNotReadyStatus'

category: 'accessing'
method: GtLlmAssistantChatNotReadyStatus
completedAt
	<return: #DateAndTime or: nil>
	^ nil
%

category: 'accessing'
method: GtLlmAssistantChatNotReadyStatus
createdAt
	<return: #DateAndTime>
	^ DateAndTime now
%

category: 'printing'
method: GtLlmAssistantChatNotReadyStatus
gtDisplayOn: stream
	stream nextPutAll: 'Ready'
%

category: 'testing'
method: GtLlmAssistantChatNotReadyStatus
isDone
	^ false
%

category: 'testing'
method: GtLlmAssistantChatNotReadyStatus
isFailed
	^ false
%

! Class implementation for 'GtLlmAssistantChatReadyStatus'

!		Instance methods for 'GtLlmAssistantChatReadyStatus'

category: 'accessing'
method: GtLlmAssistantChatReadyStatus
completedAt
	<return: #DateAndTime or: nil>
	^ DateAndTime now
%

category: 'accessing'
method: GtLlmAssistantChatReadyStatus
createdAt
	<return: #DateAndTime>
	^ DateAndTime now
%

category: 'printing'
method: GtLlmAssistantChatReadyStatus
gtDisplayOn: stream
	stream nextPutAll: 'Ready'
%

category: 'testing'
method: GtLlmAssistantChatReadyStatus
isDone
	^ true
%

category: 'testing'
method: GtLlmAssistantChatReadyStatus
isFailed
	^ false
%

! Class implementation for 'GtLlmAssistantChatWorkingStatus'

!		Instance methods for 'GtLlmAssistantChatWorkingStatus'

category: 'accessing'
method: GtLlmAssistantChatWorkingStatus
completedAt
	^ nil
%

category: 'accessing'
method: GtLlmAssistantChatWorkingStatus
createdAt
	^ DateAndTime now
%

category: 'accessing'
method: GtLlmAssistantChatWorkingStatus
isDone
	^ false
%

category: 'accessing'
method: GtLlmAssistantChatWorkingStatus
isFailed
	^ false
%

! Class implementation for 'GtLlmAssistantExamples'

!		Instance methods for 'GtLlmAssistantExamples'

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantChat
	<gtExample>
	| assistant chat |
	assistant := self assistantWithActionAndFormatAdded.
	chat := assistant createChatWithProvider: GtLlmNullProvider new.

	self assert: (chat provider isKindOf: GtLlmNullProvider).
	self assert: chat provider chat equals: chat.

	^ chat
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantChatWithInstance
	<gtExample>
	| assistant chat |
	assistant := self assistantWithActionAndFormatAdded.
	chat := assistant createChatWithProvider: GtLlmNullProvider new.
	chat onInstance: (GtLlmSerializableValueHolder new
		name: 'SomeNumber';
		content: 42;
		serializer: [ :aModel | GtLlmValueSerializer new serializeValue: aModel ];
		updater: [ :object :aString | self error: 'Unimplemented' ]).
	
	self assert: (chat provider isKindOf: GtLlmNullProvider).
	self assert: chat provider chat equals: chat.

	^ chat
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantChatWithInstanceWithMessage
	<gtExample>
	| chat serialized |
	chat := self assistantChatWithInstance.

	chat sendAction: (GtLlmActionCall action: 'example' arguments: {}).

	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	self assert: chat messages last action equals: 'example'.
	serialized := STONJSON fromString: chat messages last content.
	self assert: serialized isDictionary.
	self assert: serialized size = 3.
	self assert: (serialized at: 'Action') = 'example'.
	self assert: (serialized at: 'Arguments') isEmpty.
	self assert: (serialized includesKey: 'SomeNumber').

	^ chat
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantChatWithInstanceWithMessageIncludingSubject
	<gtExample>
	| chat serialized |
	chat := self assistantChatWithInstance.
	chat
		sendAction: (GtLlmActionCall new
				action: 'example';
				arguments: {};
				subject: (GtLlmSerializableValueHolder new
						name: 'SomeOtherNumber';
						content: 4242;
						serializer: [ :aModel | GtLlmValueSerializer new serializeValue: aModel ];
						updater: [ :object :aString | self error: 'Unimplemented' ])).

	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	self assert: chat messages last action equals: 'example'.
	serialized := STONJSON fromString: chat messages last content.
	self assert: serialized isDictionary.
	self assert: serialized size = 3.
	self assert: (serialized at: 'Action') = 'example'.
	self assert: (serialized at: 'Arguments') isEmpty.
	self assert: (serialized includesKey: 'SomeNumber') not.
	self assert: (serialized includesKey: 'SomeOtherNumber').

	^ chat
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantChatWithMessage
	<gtExample>
	| chat serialized |
	chat := self assistantChat.

	chat sendAction: (GtLlmActionCall action: 'example' arguments: {}).

	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	self assert: chat messages last action equals: 'example'.
	serialized := STONJSON fromString: chat messages last content.
	self assert: serialized isDictionary.
	self assert: serialized size = 2.
	self assert: (serialized at: 'Action') = 'example'.
	self assert: (serialized at: 'Arguments') isEmpty.

	^ chat
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantWithActionAdded
	<gtExample>
	| tutor exampleAction |
	tutor := self basicAssistant.
	exampleAction := GtLlmAssistantAction new name: 'example'.

	tutor addAction: exampleAction.

	self assert: tutor actions size equals: 2.
	self assert: (tutor actionNamed: 'example') equals: exampleAction.
	
	^ tutor
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantWithActionAddedTwice
	<gtExample>
	| tutor exampleAction errored |
	tutor := self assistantWithActionAdded.
	exampleAction := GtLlmAssistantAction new name: 'example'.
	errored := false.

	[ tutor addAction: exampleAction ] on: Error do: [ errored := true ].

	self assert: errored description: [ 'Actions should only be add-able once' ].

	^ tutor
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantWithActionAndFormatAdded
	<gtExample>
	| tutor exampleFormat |
	tutor := self assistantWithActionAdded.
	exampleFormat := GtLlmAssistantFormatDescription new
			name: 'example';
			format: 'Text'.
	tutor addFormat: exampleFormat.

	self assert: tutor instruction formats size equals: 4.
	self assert: (tutor formatNamed: 'example') equals: exampleFormat.

	^ tutor
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
assistantWithFormatAddedTwice
	<gtExample>
	| tutor exampleFormat errored |
	tutor := self assistantWithActionAndFormatAdded.
	exampleFormat := GtLlmAssistantFormatDescription new
			name: 'example';
			format: 'Text'.
	errored := false.

	[ tutor addFormat: exampleFormat ] on: Error do: [ errored := true ].

	self assert: errored description: [ 'Formats should only be add-able once' ].

	^ tutor
%

category: 'as yet unclassified'
method: GtLlmAssistantExamples
basicAssistant
	<gtExample>
	| assistant |
	assistant :=  GtLlmAssistant new.
	
	self assert: assistant actions size equals: 1.
	self assert: assistant instruction formats size equals: 3.
	self assert: assistant collectTools isEmpty.
	^ assistant
%

! Class implementation for 'GtLlmAssistantFormatDescription'

!		Class methods for 'GtLlmAssistantFormatDescription'

category: 'other'
classmethod: GtLlmAssistantFormatDescription
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmAssistantFormatDescription'

category: 'accessing'
method: GtLlmAssistantFormatDescription
addInputReference: anAction
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markInput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markInput action: anAction) ]
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
addOutputReference: anAction
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markOutput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markOutput action: anAction) ]
%

category: 'as yet unclassified'
method: GtLlmAssistantFormatDescription
asExpressionSource
	^ self class name
		, ' new
	type: ' , self type storeString
		, ';
	format: ' , self format storeString
		, ';
	name: ' , self name storeString
		, ';
	priority: ' , self priority asString
		, ';
	example: ' , self example storeString
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
asInstructionPiece
	^ GtLlmInstructionSection new
		title: self name;
		body: (GtLlmInstructionList new
				addItem: 'Name: ' , self name;
				addItem: 'Format: ' , self format;
				addItem: 'Details:
' , (self example ifNil: [ 'none' ]))
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
asJsonSchema
	| aDict |
	aDict := {'type' -> self type.
			'description'
				-> (GtLlmInstructionList new
						addItem: 'Format: ' , self format;
						addItem: 'Examples:
' , (self example ifNil: [ 'none' ])) instructionString} asDictionary.	"only relevant for arrays"
	self items ifNotNil: [ aDict at: 'items' put: self items ].

	^ aDict
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
assistant
	^ assistant
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
assistant: anObject
	assistant := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantFormatDescription
beRequired
	self type remove: 'null' ifAbsent: [  ]
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
defaultPriority
	^ 10
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
defaultType
	^ {'string'}
%

category: 'as yet unclassified'
method: GtLlmAssistantFormatDescription
definingMethod
	^ definingMethod
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
example
	^ example
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
example: anObject
	example := anObject
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
format
	^ format
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
format: anObject
	format := anObject
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
gtActionsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Referencing actions';
		priority: 5;
		items: [ referencingActions ];
		column: 'Action' text: [ :aReference | aReference action name ];
		column: 'Input'
			text: [ :aReference | aReference isInput ifTrue: [ 'true' ] ifFalse: [ '' ] ];
		column: 'Output'
			text: [ :aReference | aReference isOutput ifTrue: [ 'true' ] ifFalse: [ '' ] ]
%

category: 'as yet unclassified'
method: GtLlmAssistantFormatDescription
gtDefinitionFor: aView
	<gtView>
	^ aView forward
		title: 'Definition';
		priority: 1;
		object: [ definingMethod ];
		view: #gtSourceFor:
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
gtInstructionFor: aView
	<gtView>
	^ aView forward 
		title: 'Instruction';
		priority: 2;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
initialize
	super initialize.
	
	priority := self defaultPriority.
	
	type := self defaultType asOrderedCollection.
	
	referencingActions := OrderedCollection new.
	
	definingMethod := self initializeMethod
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
items
	^ items
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
items: anObject
	items := anObject
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
name
	^ name
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
name: anObject
	name := anObject
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
priority
	^ priority
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
priority: anObject
	priority := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantFormatDescription
removeFromSystem
	self definingMethod ifNotNil: [ :aMethod | aMethod removeFromSystem ]
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
type
	^ type
%

category: 'accessing'
method: GtLlmAssistantFormatDescription
type: anObject
	type := anObject
%

! Class implementation for 'GtLlmAssistantInstruction'

!		Class methods for 'GtLlmAssistantInstruction'

category: 'other'
classmethod: GtLlmAssistantInstruction
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmAssistantInstruction'

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
actionNamed: aString
	^ actions detect: [ :anAction | anAction name = aString ] ifNone: [ nil ]
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
actions
	^ actions
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
addAction: anAction
	(self hasActionNamed: anAction name)
		ifTrue: [ self error: 'Cannot add two LLM actions with the same name' ].
	actions add: anAction
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
addActions: aListOfActions
	actions addAll: aListOfActions
%

category: 'accessing'
method: GtLlmAssistantInstruction
addComponent: aComponent
	(self hasFormatNamed: aComponent name)
		ifTrue: [ self error: 'Cannot add two format components with the same name' ].
	formats add: aComponent
%

category: 'accessing'
method: GtLlmAssistantInstruction
addComponents: aListOfComponents
	formats addAll: aListOfComponents
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
addSection: aSection
	sections add: aSection
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
addSections: aSection
	sections addAll: aSection
%

category: 'accessing'
method: GtLlmAssistantInstruction
asInstructionPiece
	^ GtLlmInstructionWithSections new
		source: self;
		introduction: self description;
		sections: self sections
				, {GtLlmInstructionSection new
							source: self;
							title: 'Format components';
							body: (GtLlmInstructionWithSections new
									source: self;
									introduction: 'Each format component has a name, a data format (such as JSON, YAML, etc.), a Markdown code block annotation tag that encloses it, and some examples.
							
The components that make up the state are as follows:';
									sections: formats).
						GtLlmInstructionSection new
							source: self;
							title: 'Actions';
							body: (GtLlmInstructionWithSections new
									introduction: 'All actions are listed below.';
									sections: (actions collect: [ :anAction | anAction asInstructionPiece ])
											, (GtLlmFeatures multiStep ifTrue: [ {self confirmationAction} ] ifFalse: [ {} ]))}
%

category: 'accessing'
method: GtLlmAssistantInstruction
asJsonSchema
	^ {'type' -> 'object'.
		'properties'
			-> (formats
					collect: [ :aComponent | aComponent name -> aComponent asJsonSchema ])
					asDictionary.
		'required' -> (formats collect: [:aFormat | aFormat name ]).
		'additionalProperties' -> false} asDictionary
%

category: 'accessing'
method: GtLlmAssistantInstruction
communicationConventionsDescription
	| instructions |
	instructions := GtLlmInstructionList new
			addItem: 'Always review the full conversation prior to answering and maintain continuity.';
			addItem: 'Assume the user would like something concise when producing text.';
			addItem: 'Prefer asking clarifying follow-up questions or using tools (see  the section "Tool use policy") over assumptions, especially when in doubt.';
			addItem: 'Refuse actions that cannot be performed using your capabilities. When an action is refused, return a textual explanation of why it isn’t possible to fulfill the request.';
			addItem: 'Similarly, give a concise description of any error you encounter on tool use or other system errors.'.

	GtLlmFeatures multiStep
		ifTrue: [ instructions
				addItem: 'Multi-step actions (i.e. those involving tools) should be answered by a summary of the intended steps to take. If the user confirms this course of action, take it.' ].

	^ GtLlmInstructionSection new
		title: 'Communication rules';
		body: instructions
%

category: 'accessing'
method: GtLlmAssistantInstruction
componentNamed: aName
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
%

category: 'accessing'
method: GtLlmAssistantInstruction
confirmationAction
	"this is a special assistant-only action, thus it is defined here."
	^ GtLlmAssistantAction new
		name: 'Confirmation';
		priority: 1;
		description: 'Presents an action plan to the user and asks for their confirmation to perform it. It is a special action returned by the assistant if an action requires confirmation by the user.';
		examples: {GtLlmAssistantActionExample new markUnverified
					input: {'Action' -> 'Chat'.
							'Arguments' -> #('Please delete all files using your tools.')}
							asDictionary;
					output: {'Action' -> 'Confirmation'.
							'Text'
								-> 'I will delete all files using the `removeFile` tool. Do you accept?'}
							asDictionary}
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
defaultSections
	^ {self interactionDescription.
		self communicationConventionsDescription.
		self toolUseDescription} asOrderedCollection
%

category: 'accessing'
method: GtLlmAssistantInstruction
description
	^ description
%

category: 'accessing'
method: GtLlmAssistantInstruction
description: anObject
	description := anObject
%

category: 'accessing'
method: GtLlmAssistantInstruction
formatNamed: aName
	^ formats detect: [ :aComponent | aComponent name = aName ] ifNone: [ nil ]
%

category: 'accessing'
method: GtLlmAssistantInstruction
formats
	^ formats
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
gtActionsFor: aView
	<gtView>
	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [  actions ];
		view: #gtActionsFor:
%

category: 'accessing'
method: GtLlmAssistantInstruction
gtInstructionFor: aView
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstructionPiece ];
		view: #gtInstructionFor:
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
hasActionNamed: aString
	^ (self actionNamed: aString) isNotNil
%

category: 'accessing'
method: GtLlmAssistantInstruction
hasFormatNamed: aName
	^ (self formatNamed: aName) isNotNil
%

category: 'accessing'
method: GtLlmAssistantInstruction
initialize
	formats := OrderedCollection new.
	actions := GtLlmActionsGroup new.
	description := ''.
	sections := self defaultSections
%

category: 'accessing'
method: GtLlmAssistantInstruction
interactionDescription
	| body |
	body := GtLlmFeatures multiStep
			ifTrue: [ 'Interactions are structured like this:
1. The assistant (you) is given the current state and an action to perform.
2. The assistant;
    a. Determines what needs to be done. It consults tools as necessary and asks follow-up questions if the action is unclear. Multi-step actions require a summary of necessary steps beforehand and a user confirmation (see "Communication rules").
    b. Performs the action on the state.
    c. Outputs the new state.
3. The user:
	a. checks the output state.
	b. provides the current state and next action to you (returning back to step 1.).
	
The state is an aggregate of the components listed below, sent to you as a JSON object.' ]
			ifFalse: [ 'Interactions are structured like this:
1. The assistant (you) is given the current state and an action to perform.
2. The assistant;
    a. Determines what needs to be done. It consults tools as necessary and asks follow-up questions if the action is unclear.
    b. Performs the action on the state.
    c. Outputs the new state.
3. The user:
	a. checks the output state.
	b. provides the current state and next action to you (returning back to step 1.).
	
The state is an aggregate of the components listed below, sent to you as a JSON object.' ].

	^ GtLlmInstructionSection new
		title: 'Interaction description';
		body: body
%

category: 'accessing'
method: GtLlmAssistantInstruction
name
	^ name
%

category: 'accessing'
method: GtLlmAssistantInstruction
name: anObject
	name := anObject
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
replaceActions: aListOfActions
	actions removeAll addAll: aListOfActions
%

category: 'accessing'
method: GtLlmAssistantInstruction
replaceComponents: aListOfComponents
	formats removeAll addAll: aListOfComponents
%

category: 'as yet unclassified'
method: GtLlmAssistantInstruction
replaceFormatNamed: aString with: aFormat
	self formats replace: [ :each | 
		each name = aString
			ifTrue: [ aFormat ]
			ifFalse: [ each ] ].
%

category: 'accessing'
method: GtLlmAssistantInstruction
sections
	^ sections
%

category: 'accessing'
method: GtLlmAssistantInstruction
sections: anObject
	sections := anObject
%

category: 'accessing'
method: GtLlmAssistantInstruction
toolUseDescription
	^ GtLlmInstructionSection new
		title: 'Tool use policy';
		body: 'You have access to various tools. Tool use is governed by the following rules:

- Only use tools if you cannot answer the user''s question or request with certainty otherwise, except when writing code.
- When writing code, ALWAYS use tools extensively to check the environment before suggesting anything or writing code. You MUST use tools before writing any code. Failure to do so is a violation of protocol.
- Prefer checking with tools over assumptions. Verify your statements using tools unless you are absolutely certain.'
%

! Class implementation for 'GtLlmChat'

!		Class methods for 'GtLlmChat'

category: 'accessing'
classmethod: GtLlmChat
leJsonV4AttributeMapping
	"Answer the Array of attribute to store keys.
	The provider should be stored, but isn't coded yet."

	^ { #lastUpdate -> #lastUpdate.
		#messages -> #messages.
		"#serializer -> #serializer." }
%

category: 'accessing'
classmethod: GtLlmChat
leJsonV4Name

	^ #gtLlmChat
%

category: 'as yet unclassified'
classmethod: GtLlmChat
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmChat'

category: 'visiting'
method: GtLlmChat
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmChat: self
%

category: 'accessing'
method: GtLlmChat
addMessage: aMessage
	self updateLastUpdate.
	messages add: (aMessage chat: self)
%

category: 'as yet unclassified'
method: GtLlmChat
addTool: aTool 
	self provider addTool: aTool
%

category: 'accessing'
method: GtLlmChat
ancestorOf: aMessage
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = 1
						ifTrue: [ ^ nil ]
						ifFalse: [ | actualIndex |
							actualIndex := index.
							[ (messages at: actualIndex - 1) isToolRole ]
								whileTrue: [ actualIndex := actualIndex - 1 ].
							^ messages at: actualIndex - 1 ] ] ].

	self error: 'Message not found'
%

category: 'announcer'
method: GtLlmChat
announce: anAnnouncement
	^ self announcer announce: anAnnouncement
%

category: 'accessing'
method: GtLlmChat
announcer
	^ announcer ifNil: [ announcer := Announcer new ]
%

category: 'accessing'
method: GtLlmChat
assistant
	^ assistant
%

category: 'accessing'
method: GtLlmChat
assistant: anAssistant
	assistant := anAssistant
%

category: 'accessing'
method: GtLlmChat
buildDefaultProvider
	^ GtLlmConnectionRegistry uniqueInstance hasConnectableDefaultConnection
		ifTrue: [ provider := GtLlmConnectionRegistry uniqueInstance defaultConnection
					buildProvider chat: self ]
		ifFalse: [ nil ]
%

category: 'accessing'
method: GtLlmChat
descendantOf: aMessage
	messages
		withIndexDo: [ :possibleAncestor :index | 
			possibleAncestor id = aMessage id
				ifTrue: [ index = messages size ifTrue: [ ^ nil ] ifFalse: [ ^ messages at: index + 1 ] ] ].

	self error: 'Message not found'
%

category: 'ui'
method: GtLlmChat
gtMessagesFor: aView
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 3;
		items: [ self messages ];
		column: 'Role'
			text: [ :item | item role ]
			width: 100;
		column: 'Message' text: [ :item | item content ];
		updateWhen: GtLlmThreadRunAnnouncement in: self announcer;
		actionUpdateButton
%

category: 'accessing'
method: GtLlmChat
hasProvider
	^ provider isNotNil
%

category: 'accessing'
method: GtLlmChat
initialize
	super initialize.
	
	self initializeMessages.
	
	self updateLastUpdate
%

category: 'accessing'
method: GtLlmChat
initializeMessages
	messages := GtLlmMessagesGroup new
%

category: 'accessing'
method: GtLlmChat
lastUpdate
	^ lastUpdate
%

category: 'accessing'
method: GtLlmChat
lastUpdate: anObject
	lastUpdate := anObject
%

category: 'accessing'
method: GtLlmChat
messages
	^ messages
%

category: 'accessing'
method: GtLlmChat
messages: anObject
	messages := anObject.

	messages do: [ :aMessage | aMessage chat: self ]
%

category: 'accessing'
method: GtLlmChat
provider
	^ provider ifNil: [ self buildDefaultProvider ]
%

category: 'accessing'
method: GtLlmChat
provider: anObject
	provider := anObject.
	provider chat: self
%

category: 'accessing'
method: GtLlmChat
removeLastMessage
	self updateLastUpdate.
	messages removeLast
%

category: 'announcer - subscription'
method: GtLlmChat
removeSubscription: subscription
	"Remove the given subscription from the receiver"
	^ self announcer removeSubscription: subscription
%

category: 'as yet unclassified'
method: GtLlmChat
reset
	self assistant
		ifNil: [ self buildDefaultProvider ]
		ifNotNil: [ self provider: self assistant buildProvider ].
	self resetMessages
%

category: 'as yet unclassified'
method: GtLlmChat
resetMessages
	self initializeMessages.
	self signalRunIsDone
%

category: 'as yet unclassified'
method: GtLlmChat
responseFormat
	^ self provider format
%

category: 'as yet unclassified'
method: GtLlmChat
sendFiles: aListOfFileReferences withMessage: aString
	self provider
		sendFiles: aListOfFileReferences
		withMessage: aString
%

category: 'accessing'
method: GtLlmChat
sendMessage: aMessage
	self assert: aMessage isString.
	self provider sendMessage: aMessage
%

category: 'as yet unclassified'
method: GtLlmChat
signalRunHasStarted
	self announcer announce: GtLlmThreadRunStartedAnnouncement new
%

category: 'as yet unclassified'
method: GtLlmChat
signalRunHasUpdated
	self announcer announce: GtOpenAIThreadRunUpdatedAnnouncement new
%

category: 'as yet unclassified'
method: GtLlmChat
signalRunIsDone
	self announcer announce: GtLlmThreadRunIsDoneAnnouncement new
%

category: 'accessing'
method: GtLlmChat
status
	self hasProvider ifFalse: [ ^ GtLlmAssistantChatNotReadyStatus new ].

	^ self provider status
%

category: 'announcer - subscription'
method: GtLlmChat
subscribe: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@statements2' 
						-> '`@receiver when: `@statements1 do: `@statements2'.

	^ self when: anAnnouncementClass do: aValuable
%

category: 'announcer - subscription'
method: GtLlmChat
subscribe: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@aValuable for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 do: `@aValuable for: `@aSubscriber'.
	
	^ self when: anAnnouncementClass do: aValuable for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChat
subscribe: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject'.
	^ self when: anAnnouncementClass do: (MessageSend receiver: anObject selector: aSelector)
%

category: 'announcer - subscription'
method: GtLlmChat
subscribe: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber'.

	^ self when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChat
unsubscribe: anObject
	"Unsubscribe all subscriptions of anObject from the receiver"
	^ self announcer unsubscribe: anObject
%

category: 'accessing'
method: GtLlmChat
updateLastUpdate
	lastUpdate := DateAndTime now
%

category: 'announcer - subscription'
method: GtLlmChat
weak
	"announcer weak subscribe: foo"
	^ self announcer weak
%

category: 'announcer - subscription'
method: GtLlmChat
when: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that such a method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
		^ self announcer when: anAnnouncementClass do: aValuable
%

category: 'announcer - subscription'
method: GtLlmChat
when: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer when: anAnnouncementClass do: aValuable for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChat
when: anAnnouncementClass doOnce: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"
	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChat
when: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
%

category: 'announcer - subscription'
method: GtLlmChat
when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber
%

! Class implementation for 'GtLlmActionChat'

!		Class methods for 'GtLlmActionChat'

category: 'accessing'
classmethod: GtLlmActionChat
leJsonV4Name

	^ #gtLlmActionChat
%

!		Instance methods for 'GtLlmActionChat'

category: 'visiting'
method: GtLlmActionChat
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmActionChat: self
%

category: 'as yet unclassified'
method: GtLlmActionChat
defaultSerializer
	^ GtLlmActionMessageSerializer new
%

category: 'views'
method: GtLlmActionChat
gtAssistantActionsFor: aView
	<gtView>
	^ aView forward
		title: 'Assistant actions';
		object: [ assistant ];
		view: #gtActionsFor:
%

category: 'views'
method: GtLlmActionChat
gtAssistantFormatsFor: aView
	<gtView>
	^ aView forward
		title: 'Assistant formats';
		object: [ assistant ];
		view: #gtFormatComponentsFor:
%

category: 'as yet unclassified'
method: GtLlmActionChat
gtInstanceFor: aView
	<gtView>

	self gtDo: [] gemstoneDo: [ ^ aView empty ].
	instance ifNil: [ ^ aView empty ].
	
	^ aView forward
		title: 'Instance';
		priority: 2;
		object: [ instance ];
		view: #gtLiveFor:
%

category: 'views'
method: GtLlmActionChat
gtToolsFor: aView
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 10;
		object: [ provider ];
		view: #gtToolsFor:
%

category: 'as yet unclassified'
method: GtLlmActionChat
instance
	^ instance
%

category: 'as yet unclassified'
method: GtLlmActionChat
onInstance: anInstance
	instance := anInstance
%

category: 'as yet unclassified'
method: GtLlmActionChat
provider: anLlmProvider
	provider := anLlmProvider.
	anLlmProvider ifNil: [ ^ self ].
	anLlmProvider chat: self.
	assistant treatProvider: anLlmProvider
%

category: 'as yet unclassified'
method: GtLlmActionChat
sendAction: anActionCall
	^ self sendAction: anActionCall onAnswer: []
%

category: 'as yet unclassified'
method: GtLlmActionChat
sendAction: anActionCall onAnswer: aBlock
	anActionCall subject ifNil: [ anActionCall subject: instance ].
	self provider sendMessage: anActionCall serialize.
	self executeWait: aBlock
%

category: 'accessing'
method: GtLlmActionChat
sendChatRequest: aString
	^ self
		sendAction: (GtLlmActionCall new
				action: 'Chat';
				arguments: {aString})
%

category: 'accessing'
method: GtLlmActionChat
sendMessage: aMessage
	self assert: (aMessage isKindOf: GtLlmActionCall).
	^ self sendAction: aMessage
%

category: 'as yet unclassified'
method: GtLlmActionChat
updateInstance: aValue
	instance updateContent: aValue aValue
%

! Class implementation for 'GtLlmChatExamples'

!		Instance methods for 'GtLlmChatExamples'

category: 'as yet unclassified'
method: GtLlmChatExamples
basicChat
	<gtExample>
	| chat |
	chat :=  GtLlmChat new.
	
	self assert: chat messages size equals: 0.
	self assert: chat status isDone not.
	self assert: chat hasProvider not.
	
	^ chat
%

category: 'as yet unclassified'
method: GtLlmChatExamples
chatWithMessages
	<gtExample>
	| chat |
	chat := self chatWithProvider.

	chat sendMessage: 'Hi!'.
	
	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	
	^ chat
%

category: 'as yet unclassified'
method: GtLlmChatExamples
chatWithProvider
	<gtExample>
	| chat |
	chat := self basicChat.

	chat provider: GtLlmNullProvider new.

	self assert: chat provider class equals: GtLlmNullProvider.
	self assert: chat status isDone.

	^ chat
%

! Class implementation for 'GtLlmConnection'

!		Instance methods for 'GtLlmConnection'

category: 'as yet unclassified'
method: GtLlmConnection
= anotherConnection
	^anotherConnection class = self class and: 
			[self model = anotherConnection model
				and: [self provider = anotherConnection provider]]
%

category: 'as yet unclassified'
method: GtLlmConnection
addOption: anOption withValue: aValue
	meta at: anOption put: aValue
%

category: 'as yet unclassified'
method: GtLlmConnection
buildProvider
	| aProvider |
	aProvider := self provider default value.
	meta
		keysAndValuesDo: [ :aKey :aValue | aProvider perform: aKey asSymbol asMutator withArguments: {aValue} ].
	^ aProvider
%

category: 'as yet unclassified'
method: GtLlmConnection
connectionString
	^ self label ifNil: [ self model ]
%

category: 'as yet unclassified'
method: GtLlmConnection
details
	^ {'Provider' -> self provider providerName.
		'Model' -> self model.
		'Label' -> self label}
%

category: 'as yet unclassified'
method: GtLlmConnection
gtDetailsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ self details ];
		column: 'Property' text: #key;
		column: 'Value' text: #value
%

category: 'as yet unclassified'
method: GtLlmConnection
gtDisplayOn: stream
	stream
		nextPutAll: 'Connection: ';
		nextPutAll: self provider providerName;
		space;
		nextPutAll: self model;
		space;
		nextPutAll: (self isConnectable ifTrue: [ 'connectable' ] ifFalse: [ 'not connectable' ])
%

category: 'as yet unclassified'
method: GtLlmConnection
gtOptionsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Options';
		priority: 2;
		items: [ meta associations ];
		column: 'Option' text: [ :aMeta | aMeta key ];
		column: 'Value' text: [ :aMeta | aMeta value ]
%

category: 'as yet unclassified'
method: GtLlmConnection
hash
	^ self model hash xor: self provider hash
%

category: 'as yet unclassified'
method: GtLlmConnection
initialize
	super initialize.
	
	meta := Dictionary new
%

category: 'as yet unclassified'
method: GtLlmConnection
isConnectable
	^ self provider isConnectable
%

category: 'accessing'
method: GtLlmConnection
label
	^ label
%

category: 'accessing'
method: GtLlmConnection
label: anObject
	label := anObject
%

category: 'accessing'
method: GtLlmConnection
model
	^ meta at: #model ifAbsent: [ nil ]
%

category: 'accessing'
method: GtLlmConnection
model: anObject
	self addOption: #model withValue: anObject
%

category: 'accessing'
method: GtLlmConnection
provider
	^ provider
%

category: 'accessing'
method: GtLlmConnection
provider: anObject
	provider := anObject
%

category: 'as yet unclassified'
method: GtLlmConnection
providerName
	^ self provider providerName
%

! Class implementation for 'GtLlmConnectionRegistry'

!		Class methods for 'GtLlmConnectionRegistry'

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
cleanUniqueInstance
	uniqueInstance ifNotNil: [ :anInstance | 
		self onRemoveUniqueInstance: anInstance ].
	uniqueInstance := nil.
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
cleanUp
	self cleanUniqueInstance
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
default
	^ self uniqueInstance
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
hasUniqueInstance

	^ uniqueInstance isNotNil
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
instance
	<gtExample>
	^ self uniqueInstance
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
new
	^ self basicNew initialize
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
onRemoveUniqueInstance: anInstance
	"Classes may perform some activities on a singleton that is about to be released"
%

category: 'as yet unclassified'
classmethod: GtLlmConnectionRegistry
uniqueInstance
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
%

!		Instance methods for 'GtLlmConnectionRegistry'

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
addConnection: aConnection
	(connections includes: aConnection) ifTrue: [ ^ self ].
	connections add: aConnection
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
clearConnections
	connections removeAll
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
connectableConnections
	^ self connections select: [ :aConnection | aConnection isConnectable ]
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
connectionFor: aProvider
	^ connections
		detect: [ :aConnection | 
			aConnection provider = aProvider class
				and: [ aConnection model = aProvider modelName ] ]
		ifNone: [ nil ]
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
connections
	^ connections
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
defaultConnection
	^ (defaultConnection isNil or: [ defaultConnection isConnectable not ])
		ifTrue: [ self connectableConnections
				ifEmpty: [ nil ]
				ifNotEmpty: [ :aConnectionsList | aConnectionsList first ] ]
		ifFalse: [ defaultConnection ]
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
defaultConnection: aConnection
	defaultConnection := aConnection.

	(connections includes: aConnection) ifFalse: [ connections add: aConnection ]
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
hasConnectableConnection
	^ self connectableConnections isNotEmpty
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
hasConnectableDefaultConnection
	^ self defaultConnection isNotNil and: [ self defaultConnection isConnectable ]
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
initialize
	super initialize.
	
	connections := OrderedCollection withAll: self knownConnectors.
	self defaultConnection: self standardDefaultConnection
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
labelForModel: aModel
	^ connections
		detect: [ :aConnection | aConnection model = aModel ]
		ifFound: [ :aConnection | aConnection label ifNil: [ aModel ] ]
		ifNone: [ aModel ]
%

category: 'as yet unclassified'
method: GtLlmConnectionRegistry
standardDefaultConnection
	^ GtLlmConnection new
		provider: GtOpenAIResponseProvider;
		label: 'GPT 5 Codex';
		model: 'gpt-5-codex';
		addOption: 'isStreaming' withValue: false
%

! Class implementation for 'GtLlmDistanceMetric'

!		Class methods for 'GtLlmDistanceMetric'

category: 'accessing'
classmethod: GtLlmDistanceMetric
metricName
	^ self subclassResponsibility
%

!		Instance methods for 'GtLlmDistanceMetric'

category: 'accessing'
method: GtLlmDistanceMetric
distanceFrom: anEmbedding to: aQueryEmbedding
	^ self subclassResponsibility
%

! Class implementation for 'GtLlmChebyshevDistanceMetric'

!		Class methods for 'GtLlmChebyshevDistanceMetric'

category: 'accessing'
classmethod: GtLlmChebyshevDistanceMetric
metricName
	^ 'chebyshev'
%

!		Instance methods for 'GtLlmChebyshevDistanceMetric'

category: 'accessing'
method: GtLlmChebyshevDistanceMetric
distanceFrom: anEmbedding to: aQueryEmbedding
	| diff |
	diff := (anEmbedding - aQueryEmbedding) abs.
	^ diff max
%

! Class implementation for 'GtLlmCityBlockDistanceMetric'

!		Class methods for 'GtLlmCityBlockDistanceMetric'

category: 'accessing'
classmethod: GtLlmCityBlockDistanceMetric
metricName
	^ 'cityblock'
%

!		Instance methods for 'GtLlmCityBlockDistanceMetric'

category: 'accessing'
method: GtLlmCityBlockDistanceMetric
distanceFrom: anEmbedding to: aQueryEmbedding
	| diff |
	diff := (anEmbedding - aQueryEmbedding) abs.
	^ diff sum
%

! Class implementation for 'GtLlmCorrelationDistanceMetric'

!		Class methods for 'GtLlmCorrelationDistanceMetric'

category: 'accessing'
classmethod: GtLlmCorrelationDistanceMetric
metricName
	^ 'correlation'
%

!		Instance methods for 'GtLlmCorrelationDistanceMetric'

category: 'accessing'
method: GtLlmCorrelationDistanceMetric
distanceFrom: anEmbedding to: aQueryEmbedding
	| uv uu vv dist |
	uv := anEmbedding dot: aQueryEmbedding.
	uu := anEmbedding dot: anEmbedding.
	vv := aQueryEmbedding dot: aQueryEmbedding.
	dist := (1.0 - uv) / (uu * vv) sqrt.
	^ dist abs
%

! Class implementation for 'GtLlmCosineDistanceMetric'

!		Class methods for 'GtLlmCosineDistanceMetric'

category: 'accessing'
classmethod: GtLlmCosineDistanceMetric
metricName
	^ 'cosine'
%

!		Instance methods for 'GtLlmCosineDistanceMetric'

category: 'accessing'
method: GtLlmCosineDistanceMetric
distanceFrom: anEmbedding to: aQueryEmbedding
	^ ((GtLlmCorrelationDistanceMetric new distanceFrom: anEmbedding to: aQueryEmbedding) min: 2.0)
		max: 0
%

! Class implementation for 'GtLlmEmbedding'

!		Instance methods for 'GtLlmEmbedding'

category: 'accessing'
method: GtLlmEmbedding
embedding
	^ embedding
%

category: 'accessing'
method: GtLlmEmbedding
embedding: anObject
	embedding := anObject
%

category: 'accessing'
method: GtLlmEmbedding
gtEmbeddingFor: aView
	<gtView>
	^ aView list
		title: 'Embedding';
		priority: 2;
		items: [ self embedding ]
%

category: 'accessing'
method: GtLlmEmbedding
gtInputFor: aView
	<gtView>
	^ aView textEditor
		title: 'Input';
		priority: 1;
		text: [ self input ]
%

category: 'accessing'
method: GtLlmEmbedding
input
	^ input
%

category: 'accessing'
method: GtLlmEmbedding
input: anObject
	input := anObject
%

! Class implementation for 'GtLlmEmbeddingRegistry'

!		Class methods for 'GtLlmEmbeddingRegistry'

category: 'as yet unclassified'
classmethod: GtLlmEmbeddingRegistry
cleanUniqueInstance
	uniqueInstance := nil.
%

category: 'as yet unclassified'
classmethod: GtLlmEmbeddingRegistry
cleanUp
	self cleanUniqueInstance
%

category: 'as yet unclassified'
classmethod: GtLlmEmbeddingRegistry
default
	^ self uniqueInstance
%

category: 'as yet unclassified'
classmethod: GtLlmEmbeddingRegistry
hasUniqueInstance

	^ uniqueInstance isNotNil
%

category: 'as yet unclassified'
classmethod: GtLlmEmbeddingRegistry
instance
	<gtExample>
	^ self uniqueInstance
%

category: 'as yet unclassified'
classmethod: GtLlmEmbeddingRegistry
uniqueInstance
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
%

!		Instance methods for 'GtLlmEmbeddingRegistry'

category: 'accessing'
method: GtLlmEmbeddingRegistry
at: anInput
	^ embeddings at: anInput
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
at: anInput ifAbsent: aBlock
	^ embeddings at: anInput ifAbsent: aBlock
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
at: anInput ifAbsentCreateEmbedding: aBlock
	^ embeddings
		at: anInput
		ifAbsent: [ self
				put: (GtLlmEmbedding new
						input: anInput;
						embedding: aBlock value) ]
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
findNearest: aNumber for: anEmbedding
	^ self
		findNearest: aNumber
		for: anEmbedding
		usingMetric: GtLlmEmbeddingsUtilities defaultMetric
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
findNearest: aNumber for: anEmbedding usingMetric: aString
	| embeddingsWithDistances sortedByDistance |
	embeddingsWithDistances := GtLlmEmbeddingsUtilities
			distancesFromEmbeddings: (embeddings
					reject: [ :embedding | embedding input = anEmbedding input ]) values
			to: anEmbedding
			usingMetric: aString.

	sortedByDistance := embeddingsWithDistances
			sorted: [ :a :b | a distance < b distance ].

	sortedByDistance size > aNumber
		ifTrue: [ sortedByDistance := sortedByDistance first: aNumber ].

	^ GtLlmNearestEmbeddingsGroup withAll: sortedByDistance
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
initialize
	embeddings := Dictionary new
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
put: anEmbedding
	^ embeddings at: anEmbedding input put: anEmbedding
%

category: 'accessing'
method: GtLlmEmbeddingRegistry
reset
	embeddings := Dictionary new
%

! Class implementation for 'GtLlmEmbeddingsUtilities'

!		Class methods for 'GtLlmEmbeddingsUtilities'

category: 'accessing'
classmethod: GtLlmEmbeddingsUtilities
defaultMetric
	^ GtLlmCosineDistanceMetric new
%

category: 'distances'
classmethod: GtLlmEmbeddingsUtilities
distanceFrom: anEmbedding to: aQueryEmbedding usingMetric: aMetric
	^ aMetric distanceFrom: anEmbedding to: aQueryEmbedding
%

category: 'view'
classmethod: GtLlmEmbeddingsUtilities
distanceMetrics
	^ GtLlmDistanceMetric allSubclasses
%

category: 'distances'
classmethod: GtLlmEmbeddingsUtilities
distancesFromEmbeddings: listOfEmbeddings to: anEmbedding 
	^ self distancesFromEmbeddings: listOfEmbeddings to: anEmbedding usingMetric: self defaultMetric
%

category: 'distances'
classmethod: GtLlmEmbeddingsUtilities
distancesFromEmbeddings: listOfEmbeddings to: aQueryEmbedding usingMetric: aMetric
	^ listOfEmbeddings
		collect: [ :anEmbedding | 
			GtLlmNearestEmbedding new
				distance: (self
						distanceFrom: anEmbedding embedding
						to: aQueryEmbedding embedding
						usingMetric: aMetric);
				embedding: anEmbedding ]
%

category: 'view'
classmethod: GtLlmEmbeddingsUtilities
gtDistanceMetricsFor: aView
	<gtClassView>
	^ aView list
		title: 'Distance Metrics';
		priority: 50;
		items: [ self distanceMetrics ];
		itemText: [ :aClass | aClass metricName ]
%

category: 'accessing'
classmethod: GtLlmEmbeddingsUtilities
yourself
	<gtExample>
	^ self
%

! Class implementation for 'GtLlmEndpointClient'

!		Instance methods for 'GtLlmEndpointClient'

category: 'accessing'
method: GtLlmEndpointClient
client
	^ client
%

category: 'accessing'
method: GtLlmEndpointClient
client: anObject
	client := anObject
%

category: 'accessing'
method: GtLlmEndpointClient
perform
	| aResult |
	aResult := self request.

	^ (self serializationClass from: aResult) client: self client
%

category: 'accessing'
method: GtLlmEndpointClient
request
	^ self subclassResponsibility
%

category: 'accessing'
method: GtLlmEndpointClient
serializationClass
	^ self subclassResponsibility
%

! Class implementation for 'GtOllamaCompleteChatAPIClient'

!		Instance methods for 'GtOllamaCompleteChatAPIClient'

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
entity
	| entity |
	entity := {'stream' -> false.
			'model' -> self model.
			'messages' -> (self messages collect: [ :aMessage | aMessage serialize ])}
			asDictionary.

	self format ifNotNil: [ entity at: 'format' put: self format ].
	self tools
		ifNotNil: [ entity at: 'tools' put: (self tools collect: [ :aTool | aTool serialize ]) ].

	self instructions
		ifNotNil: [ (entity at: 'messages')
				addFirst: {'role' -> 'system'.
						'content' -> self instructions} asDictionary ].

	^ entity
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
format
	^ format
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
format: anObject
	format := anObject
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
instructions
	^ instructions
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
instructions: anObject
	instructions := anObject
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
messages
	^ messages
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
messages: anObject
	messages := anObject
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
model
	^ model
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
request
	^ self client post: '/chat' withEntity: self entity
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
serializationClass
	^ GtOllamaThreadMessage
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
tools
	^ tools
%

category: 'accessing'
method: GtOllamaCompleteChatAPIClient
tools: anObject
	tools := anObject
%

! Class implementation for 'GtOllamaCreateModelClient'

!		Instance methods for 'GtOllamaCreateModelClient'

category: 'accessing'
method: GtOllamaCreateModelClient
model
	^ model
%

category: 'accessing'
method: GtOllamaCreateModelClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaCreateModelClient
modelFile
	^ modelFile
%

category: 'accessing'
method: GtOllamaCreateModelClient
modelFile: anObject
	modelFile := anObject
%

category: 'accessing'
method: GtOllamaCreateModelClient
request
	^ self client
		postStreaming: '/create'
		withEntity: {'model' -> self model} asDictionary , self modelFile contentDictionary
%

category: 'accessing'
method: GtOllamaCreateModelClient
serializationClass
	^ GtOllamaStatusSteps
%

! Class implementation for 'GtOllamaDeleteModelClient'

!		Instance methods for 'GtOllamaDeleteModelClient'

category: 'accessing'
method: GtOllamaDeleteModelClient
model
	^ model
%

category: 'accessing'
method: GtOllamaDeleteModelClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaDeleteModelClient
perform
	^ self client delete: 'delete' withEntity: {'name' -> self model} asDictionary
%

! Class implementation for 'GtOllamaGenerateEmbeddingsAPIClient'

!		Instance methods for 'GtOllamaGenerateEmbeddingsAPIClient'

category: 'accessing'
method: GtOllamaGenerateEmbeddingsAPIClient
input
	^ input
%

category: 'accessing'
method: GtOllamaGenerateEmbeddingsAPIClient
input: anObject
	input := anObject
%

category: 'accessing'
method: GtOllamaGenerateEmbeddingsAPIClient
model
	^ model
%

category: 'accessing'
method: GtOllamaGenerateEmbeddingsAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaGenerateEmbeddingsAPIClient
request
	^ self client
		post: '/embed'
		withEntity: {'model' -> self model.
				'input' -> self input} asDictionary
%

category: 'accessing'
method: GtOllamaGenerateEmbeddingsAPIClient
serializationClass
	^ GtOllamaEmbeddingsGroup
%

! Class implementation for 'GtOllamaGenerateResponseClient'

!		Instance methods for 'GtOllamaGenerateResponseClient'

category: 'as yet unclassified'
method: GtOllamaGenerateResponseClient
entity
	| entity |

	entity := Dictionary new.
	entity
		at: 'model' put: model;
		at: 'prompt' put: prompt.
	format ifNotNil: [ entity at: 'format' put: format ].
	images ifNotNil: [ entity at: 'images' put: images ].
	keep_alive ifNotNil: [ entity at: 'keep_alive' put: keep_alive ].
	options ifNotNil: [ entity at: 'options' put: options ].
	suffix ifNotNil: [ entity at: 'suffix' put: suffix ].
	system ifNotNil: [ entity at: 'system' put: system ].
	template ifNotNil: [ entity at: 'template' put: template ].
	^ entity
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
format
	"The format to return a response in. Format can be json or a JSON schema"

	^ format
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
format: anObject
	format := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
images
	"(optional) a list of base64-encoded images (for multimodal models such as llava)"

	^ images
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
images: anObject
	images := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
keep_alive
	"Controls how long the model will stay loaded into memory following the request (default: 5m)"

	^ keep_alive
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
keep_alive: anObject
	keep_alive := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
model
	^ model
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
options
	"Additional model parameters listed in the documentation for the Modelfile such as temperature"

	^ options
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
options: anObject
	options := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
prompt
	"The prompt to generate a response for"

	^ prompt
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
prompt: aString

	prompt := aString
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
raw
	"If true no formatting will be applied to the prompt. You may choose to use the raw parameter if you are specifying a full templated prompt in your request to the API"

	^ raw
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
raw: aBoolean

	raw := aBoolean
%

category: 'as yet unclassified'
method: GtOllamaGenerateResponseClient
request

	^ self stream 
		ifTrue: [ self client postStreaming: '/generate' withEntity: self entity ]
		ifFalse: [ self client post: '/generate' withEntity: self entity ]
%

category: 'as yet unclassified'
method: GtOllamaGenerateResponseClient
serializationClass
	^ GtOllamaResponseMessage
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
stream
	"If false the response will be returned as a single response object, rather than a stream of objects"

	^ stream ifNil: [ true ]
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
stream: aBoolean

	stream := aBoolean
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
suffix
	"The text after the model response"

	^ suffix
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
suffix: anObject
	suffix := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
system
	"System message to (overrides what is defined in the Modelfile)"

	^ system
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
system: anObject
	system := anObject
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
template
	"The prompt template to use (overrides what is defined in the Modelfile)"

	^ template
%

category: 'accessing'
method: GtOllamaGenerateResponseClient
template: anObject
	template := anObject
%

! Class implementation for 'GtOllamaGetModelInformationAPIClient'

!		Instance methods for 'GtOllamaGetModelInformationAPIClient'

category: 'accessing'
method: GtOllamaGetModelInformationAPIClient
model
	^ model
%

category: 'accessing'
method: GtOllamaGetModelInformationAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaGetModelInformationAPIClient
request
	^ (self client
		postStreaming: '/show'
		withEntity: {'model' -> self model.
				'verbose' -> true} asDictionary) first
%

category: 'accessing'
method: GtOllamaGetModelInformationAPIClient
serializationClass
	^ GtOllamaModelInformation
%

! Class implementation for 'GtOllamaListModelsClient'

!		Instance methods for 'GtOllamaListModelsClient'

category: 'accessing'
method: GtOllamaListModelsClient
request
	^ self client get: '/tags'
%

category: 'accessing'
method: GtOllamaListModelsClient
serializationClass
	^ GtOllamaModelsGroup
%

! Class implementation for 'GtOllamaListRunningModelsClient'

!		Instance methods for 'GtOllamaListRunningModelsClient'

category: 'accessing'
method: GtOllamaListRunningModelsClient
request
	^ self client get: '/ps'
%

category: 'accessing'
method: GtOllamaListRunningModelsClient
serializationClass
	^ GtOllamaRunningModelsGroup
%

! Class implementation for 'GtOllamaPullModelClient'

!		Instance methods for 'GtOllamaPullModelClient'

category: 'accessing'
method: GtOllamaPullModelClient
model
	^ model
%

category: 'accessing'
method: GtOllamaPullModelClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaPullModelClient
request
	^ self client postStreaming: '/pull' withEntity: {'model' -> self model} asDictionary
%

category: 'accessing'
method: GtOllamaPullModelClient
serializationClass
	^ GtOllamaStatusSteps
%

! Class implementation for 'GtOllamaPushModelClient'

!		Instance methods for 'GtOllamaPushModelClient'

category: 'accessing'
method: GtOllamaPushModelClient
model
	^ model
%

category: 'accessing'
method: GtOllamaPushModelClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaPushModelClient
request
	^ self client postStreaming: '/push' withEntity: {'model' -> self model} asDictionary
%

category: 'accessing'
method: GtOllamaPushModelClient
serializationClass
	^ GtOllamaStatusSteps
%

! Class implementation for 'GtOpenAIAddMessageToThreadAPIClient'

!		Instance methods for 'GtOpenAIAddMessageToThreadAPIClient'

category: 'accessing'
method: GtOpenAIAddMessageToThreadAPIClient
message
	^ message
%

category: 'accessing'
method: GtOpenAIAddMessageToThreadAPIClient
message: anObject
	message := anObject
%

category: 'accessing'
method: GtOpenAIAddMessageToThreadAPIClient
request
	^ self client
		post: 'threads/' , self thread , '/messages'
		withEntity: self message serialize
%

category: 'accessing'
method: GtOpenAIAddMessageToThreadAPIClient
serializationClass
	^ GtOpenAIMessage
%

category: 'accessing'
method: GtOpenAIAddMessageToThreadAPIClient
thread
	^ thread
%

category: 'accessing'
method: GtOpenAIAddMessageToThreadAPIClient
thread: anObject
	thread := anObject
%

! Class implementation for 'GtOpenAICompleteChatAPIClient'

!		Instance methods for 'GtOpenAICompleteChatAPIClient'

category: 'accessing'
method: GtOpenAICompleteChatAPIClient
messages
	^ messages
%

category: 'accessing'
method: GtOpenAICompleteChatAPIClient
messages: anObject
	messages := anObject
%

category: 'accessing'
method: GtOpenAICompleteChatAPIClient
model
	^ model
%

category: 'accessing'
method: GtOpenAICompleteChatAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAICompleteChatAPIClient
request
	^ self client
		post: '/chat/completions'
		withEntity: {'model' -> self model.
				'messages' -> (self messages collect: [:aMessage | aMessage serialize ])} asDictionary
%

category: 'accessing'
method: GtOpenAICompleteChatAPIClient
serializationClass
	^ GtOpenAIChatCompletion
%

! Class implementation for 'GtOpenAICreateAssistantAPIClient'

!		Instance methods for 'GtOpenAICreateAssistantAPIClient'

category: 'accessing'
method: GtOpenAICreateAssistantAPIClient
assistant
	^ assistant
%

category: 'accessing'
method: GtOpenAICreateAssistantAPIClient
assistant: anObject
	assistant := anObject
%

category: 'accessing'
method: GtOpenAICreateAssistantAPIClient
request
	^ self client
		post: '/assistants'
		withEntity: self assistant serialize
%

category: 'accessing'
method: GtOpenAICreateAssistantAPIClient
serializationClass
	^ GtOpenAIAssistant
%

! Class implementation for 'GtOpenAICreateAssistantFileAPIClient'

!		Instance methods for 'GtOpenAICreateAssistantFileAPIClient'

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
assistant
	^ assistant
%

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
assistant: anObject
	assistant := anObject
%

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
file
	^ file
%

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
file: anObject
	file := anObject
%

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
makeRequest
	^ self client
		post: 'assistants/' , self assistant , '/files'
		withEntity: {'file_id' -> self file} asDictionary
%

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
request
	"the file API fails the first time certain (seemingly larger) files are being associated with assistants; retry once if it happens"
	^ [ self makeRequest ]
		on: GtOpenAIError
		do: [ self makeRequest ]
%

category: 'accessing'
method: GtOpenAICreateAssistantFileAPIClient
serializationClass
	^ GtOpenAIAssistantFile
%

! Class implementation for 'GtOpenAICreateFineTuningJobAPIClient'

!		Instance methods for 'GtOpenAICreateFineTuningJobAPIClient'

category: 'accessing'
method: GtOpenAICreateFineTuningJobAPIClient
file
	^ file
%

category: 'accessing'
method: GtOpenAICreateFineTuningJobAPIClient
file: anObject
	file := anObject
%

category: 'accessing'
method: GtOpenAICreateFineTuningJobAPIClient
model
	^ model
%

category: 'accessing'
method: GtOpenAICreateFineTuningJobAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAICreateFineTuningJobAPIClient
request
	^ self client
		post: 'fine_tuning/jobs'
		withEntity: {'training_file' -> self file.
				'model' -> self model} asDictionary
%

category: 'accessing'
method: GtOpenAICreateFineTuningJobAPIClient
serializationClass
	^ GtOpenAIFineTuningJob
%

! Class implementation for 'GtOpenAICreateThreadAPIClient'

!		Instance methods for 'GtOpenAICreateThreadAPIClient'

category: 'accessing'
method: GtOpenAICreateThreadAPIClient
messages
	^ messages
%

category: 'accessing'
method: GtOpenAICreateThreadAPIClient
messages: anObject
	messages := anObject
%

category: 'accessing'
method: GtOpenAICreateThreadAPIClient
request
	^ self client
		post: 'threads'
		withEntity: {'messages' -> (self messages collect: #serialize)} asDictionary
%

category: 'accessing'
method: GtOpenAICreateThreadAPIClient
serializationClass
	^ GtOpenAIThread
%

! Class implementation for 'GtOpenAICreateThreadRunAPIClient'

!		Instance methods for 'GtOpenAICreateThreadRunAPIClient'

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
assistant
	^ assistant
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
assistant: anObject
	assistant := anObject
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
request
	^ self client
		post: 'threads/' , self thread , '/runs'
		withEntity: {'assistant_id' -> self assistant.
				'response_format' -> self responseFormat} asDictionary
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
responseFormat
	^ responseFormat
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
responseFormat: anObject
	responseFormat := anObject
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
serializationClass
	^ GtOpenAIThreadRun
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
thread
	^ thread
%

category: 'accessing'
method: GtOpenAICreateThreadRunAPIClient
thread: anObject
	thread := anObject
%

! Class implementation for 'GtOpenAICreateVectorStoreAPIClient'

!		Instance methods for 'GtOpenAICreateVectorStoreAPIClient'

category: 'accessing'
method: GtOpenAICreateVectorStoreAPIClient
files
	^ files
%

category: 'accessing'
method: GtOpenAICreateVectorStoreAPIClient
files: anObject
	files := anObject
%

category: 'accessing'
method: GtOpenAICreateVectorStoreAPIClient
name
	^ name
%

category: 'accessing'
method: GtOpenAICreateVectorStoreAPIClient
name: anObject
	name := anObject
%

category: 'as yet unclassified'
method: GtOpenAICreateVectorStoreAPIClient
request
	^ self client
		post: 'vector_stores'
		withEntity: {'name' -> self name.
				'file_ids' -> self files} asDictionary
%

category: 'as yet unclassified'
method: GtOpenAICreateVectorStoreAPIClient
serializationClass
	^ GtOpenAIVectorStore
%

! Class implementation for 'GtOpenAIDeleteAssistantAPIClient'

!		Instance methods for 'GtOpenAIDeleteAssistantAPIClient'

category: 'accessing'
method: GtOpenAIDeleteAssistantAPIClient
assistant
	^ assistant
%

category: 'accessing'
method: GtOpenAIDeleteAssistantAPIClient
assistant: anObject
	assistant := anObject
%

category: 'accessing'
method: GtOpenAIDeleteAssistantAPIClient
request
	^ self client
		delete: 'assistants/', assistant
%

category: 'accessing'
method: GtOpenAIDeleteAssistantAPIClient
serializationClass
	^ GtOpenAIDeletion
%

! Class implementation for 'GtOpenAIDeleteFileAPIClient'

!		Instance methods for 'GtOpenAIDeleteFileAPIClient'

category: 'accessing'
method: GtOpenAIDeleteFileAPIClient
file
	^ file
%

category: 'accessing'
method: GtOpenAIDeleteFileAPIClient
file: anObject
	file := anObject
%

category: 'accessing'
method: GtOpenAIDeleteFileAPIClient
request
	^ self client
		delete: 'files/', file
%

category: 'accessing'
method: GtOpenAIDeleteFileAPIClient
serializationClass
	^ GtOpenAIDeletion
%

! Class implementation for 'GtOpenAIDeleteModelAPIClient'

!		Instance methods for 'GtOpenAIDeleteModelAPIClient'

category: 'accessing'
method: GtOpenAIDeleteModelAPIClient
model
	^ model
%

category: 'accessing'
method: GtOpenAIDeleteModelAPIClient
model: anObject
	model := anObject
%

category: 'as yet unclassified'
method: GtOpenAIDeleteModelAPIClient
request
	^ self client delete: 'models/' , model
%

category: 'as yet unclassified'
method: GtOpenAIDeleteModelAPIClient
serializationClass
	^ GtOpenAIDeletion
%

! Class implementation for 'GtOpenAIDeleteVectorStoreAPIClient'

!		Instance methods for 'GtOpenAIDeleteVectorStoreAPIClient'

category: 'as yet unclassified'
method: GtOpenAIDeleteVectorStoreAPIClient
request
	^ self client
		delete: 'vector_stores/', vectorStore
%

category: 'as yet unclassified'
method: GtOpenAIDeleteVectorStoreAPIClient
serializationClass
	^ GtOpenAIDeletion
%

category: 'accessing'
method: GtOpenAIDeleteVectorStoreAPIClient
vectorStore
	^ vectorStore
%

category: 'accessing'
method: GtOpenAIDeleteVectorStoreAPIClient
vectorStore: anObject
	vectorStore := anObject
%

! Class implementation for 'GtOpenAIGenerateEmbeddingAPIClient'

!		Instance methods for 'GtOpenAIGenerateEmbeddingAPIClient'

category: 'accessing'
method: GtOpenAIGenerateEmbeddingAPIClient
input
	^ input
%

category: 'accessing'
method: GtOpenAIGenerateEmbeddingAPIClient
input: anObject
	input := anObject
%

category: 'accessing'
method: GtOpenAIGenerateEmbeddingAPIClient
model
	^ model
%

category: 'accessing'
method: GtOpenAIGenerateEmbeddingAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIGenerateEmbeddingAPIClient
request
	^ self client
		post: 'embeddings'
		withEntity: {'model' -> self model.
				'input' -> self input} asDictionary
%

category: 'accessing'
method: GtOpenAIGenerateEmbeddingAPIClient
serializationClass
	^ GtOpenAIEmbeddingsGroup
%

! Class implementation for 'GtOpenAIGenerateResponseAPIClient'

!		Instance methods for 'GtOpenAIGenerateResponseAPIClient'

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
buildEntity
	| entity |
	entity := {'model' -> self model.
			'stream' -> isStreaming.
			'input'
				-> (self messages
						flatCollect: [ :aMessage | 
							(aMessage isKindOf: GtLlmToolMessage)
								ifTrue: [ {aMessage serializeResponse} ]
								ifFalse: [ (aMessage isKindOf: GtOpenAIRawToolMessage)
										ifTrue: [ (aMessage reasoning ifNil: [ {} ] ifNotNil: [ {aMessage reasoning rawData} ])
												, {aMessage serialize} ]
										ifFalse: [ {aMessage serialize} ] ] ])} asDictionary.

	format
		ifNotNil: [ entity
				at: 'text'
				put: {'format'
							-> {'type' -> 'json_schema'.
									'name' -> 'JsonSchema'.
									'schema' -> format} asDictionary} asDictionary ].

	tools isEmptyOrNil
		ifFalse: [ entity
				at: 'tools'
				put: (self tools collect: [ :aTool | aTool functionResponse ]) ].

	instructions ifNotNil: [ entity at: 'instructions' put: instructions ].

	^ entity
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
format
	^ format
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
format: anObject
	format := anObject
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
instructions
	^ instructions
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
instructions: anObject
	instructions := anObject
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
isStreaming
	^ isStreaming
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
isStreaming: anObject
	isStreaming := anObject
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
messages
	^ messages
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
messages: anObject
	messages := anObject
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
model
	^ model
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIGenerateResponseAPIClient
tools: anObject
	tools := anObject
%

! Class implementation for 'GtOpenAIGetFileAPIClient'

!		Instance methods for 'GtOpenAIGetFileAPIClient'

category: 'accessing'
method: GtOpenAIGetFileAPIClient
file
	^ file
%

category: 'accessing'
method: GtOpenAIGetFileAPIClient
file: anObject
	file := anObject
%

category: 'accessing'
method: GtOpenAIGetFileAPIClient
request
	^ self client get: '/files/', self file
%

category: 'accessing'
method: GtOpenAIGetFileAPIClient
serializationClass
	^ GtOpenAIFile
%

! Class implementation for 'GtOpenAIGetFileContentsAPIClient'

!		Instance methods for 'GtOpenAIGetFileContentsAPIClient'

category: 'accessing'
method: GtOpenAIGetFileContentsAPIClient
file
	^ file
%

category: 'accessing'
method: GtOpenAIGetFileContentsAPIClient
file: anObject
	file := anObject
%

! Class implementation for 'GtOpenAIGetFineTuningJobAPIClient'

!		Instance methods for 'GtOpenAIGetFineTuningJobAPIClient'

category: 'accessing'
method: GtOpenAIGetFineTuningJobAPIClient
job
	^ job
%

category: 'accessing'
method: GtOpenAIGetFineTuningJobAPIClient
job: anObject
	job := anObject
%

category: 'accessing'
method: GtOpenAIGetFineTuningJobAPIClient
request
	^ self client get: '/fine_tuning/jobs/' , self job
%

category: 'accessing'
method: GtOpenAIGetFineTuningJobAPIClient
serializationClass
	^ GtOpenAIFineTuningJob
%

! Class implementation for 'GtOpenAIGetFineTuningCheckpointsForJobAPIClient'

!		Instance methods for 'GtOpenAIGetFineTuningCheckpointsForJobAPIClient'

category: 'accessing'
method: GtOpenAIGetFineTuningCheckpointsForJobAPIClient
request
	^ self client get: '/fine_tuning/jobs/' , self job , '/checkpoints'
%

category: 'accessing'
method: GtOpenAIGetFineTuningCheckpointsForJobAPIClient
serializationClass
	^ GtOpenAIFineTuningCheckpointsGroup
%

! Class implementation for 'GtOpenAIGetFineTuningEventsForJobAPIClient'

!		Instance methods for 'GtOpenAIGetFineTuningEventsForJobAPIClient'

category: 'accessing'
method: GtOpenAIGetFineTuningEventsForJobAPIClient
request
	^ self client get: '/fine_tuning/jobs/' , self job , '/events' withParams: {'limit' -> 1000}
%

category: 'accessing'
method: GtOpenAIGetFineTuningEventsForJobAPIClient
serializationClass
	^ GtOpenAIFineTuningEventsGroup
%

! Class implementation for 'GtOpenAIGetThreadRunAPIClient'

!		Instance methods for 'GtOpenAIGetThreadRunAPIClient'

category: 'accessing'
method: GtOpenAIGetThreadRunAPIClient
request
	^ self client get: 'threads/' , self thread , '/runs/' , self run
%

category: 'accessing'
method: GtOpenAIGetThreadRunAPIClient
run
	^ run
%

category: 'accessing'
method: GtOpenAIGetThreadRunAPIClient
run: anObject
	run := anObject
%

category: 'accessing'
method: GtOpenAIGetThreadRunAPIClient
serializationClass
	^ GtOpenAIThreadRun
%

category: 'accessing'
method: GtOpenAIGetThreadRunAPIClient
thread
	^ thread
%

category: 'accessing'
method: GtOpenAIGetThreadRunAPIClient
thread: anObject
	thread := anObject
%

! Class implementation for 'GtOpenAIListAssistantsAPIClient'

!		Instance methods for 'GtOpenAIListAssistantsAPIClient'

category: 'as yet unclassified'
method: GtOpenAIListAssistantsAPIClient
request
	^ self client get: '/assistants'
%

category: 'as yet unclassified'
method: GtOpenAIListAssistantsAPIClient
serializationClass
	^ GtOpenAIAssistantsGroup
%

! Class implementation for 'GtOpenAIListFilesAPIClient'

!		Instance methods for 'GtOpenAIListFilesAPIClient'

category: 'as yet unclassified'
method: GtOpenAIListFilesAPIClient
request
	^ self client get: '/files'
%

category: 'as yet unclassified'
method: GtOpenAIListFilesAPIClient
serializationClass
	^ GtOpenAIFilesGroup
%

! Class implementation for 'GtOpenAIListModelsAPIClient'

!		Instance methods for 'GtOpenAIListModelsAPIClient'

category: 'accessing'
method: GtOpenAIListModelsAPIClient
request
	^ self client get: '/models'
%

category: 'accessing'
method: GtOpenAIListModelsAPIClient
serializationClass
	^ GtOpenAIModelsGroup
%

! Class implementation for 'GtOpenAIListThreadMessagesAPIClient'

!		Class methods for 'GtOpenAIListThreadMessagesAPIClient'

category: 'other'
classmethod: GtOpenAIListThreadMessagesAPIClient
new
	^ self basicNew initialize
%

!		Instance methods for 'GtOpenAIListThreadMessagesAPIClient'

category: 'as yet unclassified'
method: GtOpenAIListThreadMessagesAPIClient
defaultParams
	^ {'limit' -> 100.
		'order' -> 'asc'}
%

category: 'as yet unclassified'
method: GtOpenAIListThreadMessagesAPIClient
initialize
	super initialize.

	params := self defaultParams
%

category: 'accessing'
method: GtOpenAIListThreadMessagesAPIClient
params
	^ params
%

category: 'accessing'
method: GtOpenAIListThreadMessagesAPIClient
params: anObject
	params := anObject
%

category: 'accessing'
method: GtOpenAIListThreadMessagesAPIClient
request
	^ self client
		get: 'threads/' , self thread , '/messages'
		withParams: self params
%

category: 'accessing'
method: GtOpenAIListThreadMessagesAPIClient
serializationClass
	^ GtOpenAIMessagesGroup
%

category: 'accessing'
method: GtOpenAIListThreadMessagesAPIClient
thread
	^ thread
%

category: 'accessing'
method: GtOpenAIListThreadMessagesAPIClient
thread: anObject
	thread := anObject
%

! Class implementation for 'GtOpenAIListVectorStoresAPIClient'

!		Instance methods for 'GtOpenAIListVectorStoresAPIClient'

category: 'as yet unclassified'
method: GtOpenAIListVectorStoresAPIClient
request
	^ self client get: '/vector_stores'
%

category: 'as yet unclassified'
method: GtOpenAIListVectorStoresAPIClient
serializationClass
	^ GtOpenAIVectorStoresGroup
%

! Class implementation for 'GtOpenAISubmitToolOutputsAPIClient'

!		Instance methods for 'GtOpenAISubmitToolOutputsAPIClient'

category: 'accessing'
method: GtOpenAISubmitToolOutputsAPIClient
outputs
	^ outputs
%

category: 'accessing'
method: GtOpenAISubmitToolOutputsAPIClient
outputs: anObject
	outputs := anObject
%

category: 'as yet unclassified'
method: GtOpenAISubmitToolOutputsAPIClient
request
	^ self client
		post: 'threads/' , self thread , '/runs/' , self run , '/submit_tool_outputs'
		withEntity: {'tool_outputs' -> self outputs} asDictionary
%

category: 'accessing'
method: GtOpenAISubmitToolOutputsAPIClient
run
	^ run
%

category: 'accessing'
method: GtOpenAISubmitToolOutputsAPIClient
run: anObject
	run := anObject
%

category: 'as yet unclassified'
method: GtOpenAISubmitToolOutputsAPIClient
serializationClass
	^ GtOpenAIThreadRun
%

category: 'accessing'
method: GtOpenAISubmitToolOutputsAPIClient
thread
	^ thread
%

category: 'accessing'
method: GtOpenAISubmitToolOutputsAPIClient
thread: anObject
	thread := anObject
%

! Class implementation for 'GtOpenAIUploadFileAPIClient'

!		Instance methods for 'GtOpenAIUploadFileAPIClient'

category: 'accessing'
method: GtOpenAIUploadFileAPIClient
file
	^ file
%

category: 'accessing'
method: GtOpenAIUploadFileAPIClient
file: anObject
	file := anObject
%

category: 'accessing'
method: GtOpenAIUploadFileAPIClient
purpose
	^ purpose
%

category: 'accessing'
method: GtOpenAIUploadFileAPIClient
purpose: anObject
	purpose := anObject
%

category: 'accessing'
method: GtOpenAIUploadFileAPIClient
serializationClass
	^ GtOpenAIFile
%

! Class implementation for 'GtLlmEntity'

!		Class methods for 'GtLlmEntity'

category: 'accessing'
classmethod: GtLlmEntity
from: aDictionary
	| entity |

	(aDictionary isKindOf: self) ifTrue: [ ^ aDictionary ].

	(self isErrorResult: aDictionary)
		ifTrue: [ self error: (aDictionary at: 'error') ].

	entity := self new.
	entity from: aDictionary.
	^ entity
%

category: 'testing'
classmethod: GtLlmEntity
isErrorResult: aDictionary
	^ aDictionary size = 1 and: [ aDictionary includesKey: 'error' ]
%

category: 'accessing'
classmethod: GtLlmEntity
leJsonV4AttributeMapping

	^ OrderedCollection 
		with: #rawData -> #rawData
		with: #client -> #client
%

category: 'accessing'
classmethod: GtLlmEntity
leJsonV4Name

	^ #gtLlmEntity
%

category: 'accessing'
classmethod: GtLlmEntity
serializationProperties
	^ #()
%

!		Instance methods for 'GtLlmEntity'

category: 'visiting'
method: GtLlmEntity
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmEntity: self
%

category: 'accessing'
method: GtLlmEntity
client
	^ client
%

category: 'accessing'
method: GtLlmEntity
client: anObject
	client := anObject
%

category: 'as yet unclassified'
method: GtLlmEntity
deserializeTime: anObject
	^ (anObject isNil or: [ anObject isKindOf: DateAndTime ])
		ifTrue: [ anObject ]
		ifFalse: [ DateAndTime fromUnixTime: anObject ]
%

category: 'as yet unclassified'
method: GtLlmEntity
from: aDictionary
	self rawData: aDictionary.

	self class serializationProperties
		do: [ :aPair | 
			self
				perform: aPair value asSymbol asMutator
				withArguments: {aDictionary at: aPair key asString ifAbsent: [ nil ]} ]
%

category: 'accessing'
method: GtLlmEntity
gtViewRawDataFor: aView
	<gtView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
%

category: 'as yet unclassified'
method: GtLlmEntity
merge: anotherEntity
	self rawData: anotherEntity rawData.

	self class serializationProperties
		do: [ :aPair | 
			| aValue |
			aValue := anotherEntity perform: aPair value.
			aValue
				ifNotNil: [ self perform: (aPair value , ':') asSymbol withArguments: {aValue} ] ]
%

category: 'accessing'
method: GtLlmEntity
rawData
	^ rawData
%

category: 'accessing'
method: GtLlmEntity
rawData: anObject
	rawData := anObject
%

category: 'accessing'
method: GtLlmEntity
serialize
	^ (self class serializationProperties
		collect: [ :aPair | aPair key -> (self perform: aPair value) ]) asDictionary
		reject: [ :aValue | aValue isNil ]
%

! Class implementation for 'GtLlmChatMessage'

!		Class methods for 'GtLlmChatMessage'

category: 'accessing'
classmethod: GtLlmChatMessage
defaultRole
	^ self subclassResponsibility
%

category: 'accessing'
classmethod: GtLlmChatMessage
deSerializeAllImplementorsInstances
	"Answer a collection of instances to be tested for serialisation / deserialisation"

	^ self name = #GtLlmChatMessage
		ifTrue: [ #() ]
		ifFalse: [ { self new } ]
%

category: 'instance creation'
classmethod: GtLlmChatMessage
from: aDictionary
	| aRole aContent roleClass |
	self isAbstract ifFalse: [ ^ self new from: aDictionary ].

	aRole := aDictionary at: 'role'.
	aContent := aDictionary at: 'content'.

	roleClass := self rolesToClasses at: aRole ifAbsent: [ self ].

	^ roleClass new from: aDictionary
%

category: 'accessing'
classmethod: GtLlmChatMessage
leJsonV4AttributeMapping

	^ super leJsonV4AttributeMapping
		add: #content -> #content;
		add: #role -> #role;
		add: #id -> #id;
		add: #createdAt -> #createdAt;
		add: #images -> #images;
		add: #model -> #model;
		yourself.
%

category: 'accessing'
classmethod: GtLlmChatMessage
leJsonV4Name

	^ #gtLlmChatMessage
%

category: 'instance creation'
classmethod: GtLlmChatMessage
rolesToClasses
	^ {('tool' -> GtLlmToolMessage).
	('assistant' -> GtLlmAssistantMessage).
	('user' -> GtLlmUserMessage).
	('system' -> GtLlmSystemMessage)} asDictionary
%

category: 'accessing'
classmethod: GtLlmChatMessage
serializationProperties
	^ {#role -> #role.
		#content -> #content}
%

!		Instance methods for 'GtLlmChatMessage'

category: 'visiting'
method: GtLlmChatMessage
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmChatMessage: self
%

category: 'as yet unclassified'
method: GtLlmChatMessage
action
	^ [ self contentJson at: 'Action' ] on: Error do: [ nil ]
%

category: 'as yet unclassified'
method: GtLlmChatMessage
ancestor
	^ self chat ancestorOf: self
%

category: 'accessing'
method: GtLlmChatMessage
annotations
	^ {}
%

category: 'announcer'
method: GtLlmChatMessage
announce: anAnnouncement
	^ self announcer announce: anAnnouncement
%

category: 'announcer'
method: GtLlmChatMessage
announcer
	<return: #Announcer>
	^ announcer ifNil: [announcer := Announcer new]
%

category: 'as yet unclassified'
method: GtLlmChatMessage
arguments
	^ [ self contentJson at: 'Arguments' ] on: Error do: [ nil ]
%

category: 'accessing'
method: GtLlmChatMessage
asTokenizableString
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
%

category: 'accessing'
method: GtLlmChatMessage
chat
	^ chat
%

category: 'accessing'
method: GtLlmChatMessage
chat: anObject
	chat := anObject
%

category: 'accessing'
method: GtLlmChatMessage
content
	^ content
%

category: 'accessing'
method: GtLlmChatMessage
content: anObject
	content := anObject.
	
	self announce: GtLlmMessageContentsUpdated new
%

category: 'accessing'
method: GtLlmChatMessage
contentFiles
	^ (self content isKindOf: String)
		ifTrue: [ {} ]
		ifFalse: [ content
				select: [ :aValue | (aValue at: #type) = 'image' ]
				thenCollect: [ :aValue | 
					aValue
						at: #source
						at: #data
						ifAbsent: [ '' ] ] ]
%

category: 'as yet unclassified'
method: GtLlmChatMessage
contentJson
	^ [ | ston value |
	ston := STON reader on: self contentText readStream.
	value := ston next.
	self assert: ston atEnd.
	value ] on: Error do: [ {'Text' -> self contentText} asDictionary ]
%

category: 'accessing'
method: GtLlmChatMessage
contentSummary
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
%

category: 'accessing'
method: GtLlmChatMessage
contentText
	^ (self content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						select: [ :aValue | (aValue at: #type) = 'text' ]
						thenCollect: [ :aValue | (aValue at: #text) ifNil: [ '' ] ]) ]
%

category: 'accessing'
method: GtLlmChatMessage
createdAt
	^ createdAt
%

category: 'accessing'
method: GtLlmChatMessage
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtLlmChatMessage
descendant
	^ self chat descendantOf: self
%

category: 'as yet unclassified'
method: GtLlmChatMessage
gtActionInspectFor: anAction
	<gtAction>
	<gtLlmAction>
	^ super gtActionInspectFor: anAction
%

category: 'accessing'
method: GtLlmChatMessage
hasResponse
	^ true
%

category: 'announcer'
method: GtLlmChatMessage
hasSubscriber: anObject
	^ self announcer hasSubscriber: anObject
%

category: 'accessing'
method: GtLlmChatMessage
id
	^ id
%

category: 'as yet unclassified'
method: GtLlmChatMessage
id: anId
	id := anId
%

category: 'accessing'
method: GtLlmChatMessage
images
	^ images
%

category: 'accessing'
method: GtLlmChatMessage
images: anObject
	images := anObject
%

category: 'accessing'
method: GtLlmChatMessage
initialize
	id := self uuidClass new.
	createdAt := DateAndTime now.
	images := OrderedCollection new
%

category: 'accessing'
method: GtLlmChatMessage
isAssistantRole
	^ self role = 'assistant'
%

category: 'accessing'
method: GtLlmChatMessage
isFailure
	^ false
%

category: 'as yet unclassified'
method: GtLlmChatMessage
isRawMessage
	^ false
%

category: 'as yet unclassified'
method: GtLlmChatMessage
isReady
	^ true
%

category: 'accessing'
method: GtLlmChatMessage
isSystemRole
	^ self role = 'system'
%

category: 'accessing'
method: GtLlmChatMessage
isToolRole
	^ self role = 'tool'
%

category: 'accessing'
method: GtLlmChatMessage
isUserRole
	^ self role = 'user'
%

category: 'accessing'
method: GtLlmChatMessage
model
	^ model
%

category: 'accessing'
method: GtLlmChatMessage
model: anObject
	model := anObject
%

category: 'announcer - subscription'
method: GtLlmChatMessage
removeSubscription: subscription
	"Remove the given subscription from the receiver"
	^ self announcer removeSubscription: subscription
%

category: 'accessing'
method: GtLlmChatMessage
role
	^ role ifNil: [ role := self class defaultRole ]
%

category: 'accessing'
method: GtLlmChatMessage
role: anObject
	role := anObject
%

category: 'accessing'
method: GtLlmChatMessage
senderText
	self isAssistantRole
		ifTrue: [ ^ self model
				ifNil: [ 'Assistant' ]
				ifNotNil: [ :aModel | GtLlmConnectionRegistry uniqueInstance labelForModel: aModel ] ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	self isToolRole ifTrue: [ ^ 'Tool' ].
	^ 'You'
%

category: 'as yet unclassified'
method: GtLlmChatMessage
serialize
	| serialized |
	serialized := super serialize.

	self images isEmptyOrNil ifFalse: [ serialized at: 'images' put: self images ].

	^ serialized
%

category: 'as yet unclassified'
method: GtLlmChatMessage
serializeInline
%

category: 'announcer - subscription'
method: GtLlmChatMessage
subscribe: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@statements2' 
						-> '`@receiver when: `@statements1 do: `@statements2'.

	^ self when: anAnnouncementClass do: aValuable
%

category: 'announcer - subscription'
method: GtLlmChatMessage
subscribe: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@aValuable for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 do: `@aValuable for: `@aSubscriber'.
	
	^ self when: anAnnouncementClass do: aValuable for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChatMessage
subscribe: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject'.
	^ self when: anAnnouncementClass do: (MessageSend receiver: anObject selector: aSelector)
%

category: 'announcer - subscription'
method: GtLlmChatMessage
subscribe: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber'.

	^ self when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChatMessage
unsubscribe: anObject
	"Unsubscribe all subscriptions of anObject from the receiver"
	^ self announcer unsubscribe: anObject
%

category: 'announcer - subscription'
method: GtLlmChatMessage
weak
	"announcer weak subscribe: foo"
	^ self announcer weak
%

category: 'announcer - subscription'
method: GtLlmChatMessage
when: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that such a method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
		^ self announcer when: anAnnouncementClass do: aValuable
%

category: 'announcer - subscription'
method: GtLlmChatMessage
when: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer when: anAnnouncementClass do: aValuable for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChatMessage
when: anAnnouncementClass doOnce: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"
	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmChatMessage
when: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
%

category: 'announcer - subscription'
method: GtLlmChatMessage
when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber
%

! Class implementation for 'GtLlmActionMessage'

!		Class methods for 'GtLlmActionMessage'

category: 'as yet unclassified'
classmethod: GtLlmActionMessage
defaultRole
	^ nil
%

category: 'accessing'
classmethod: GtLlmActionMessage
leJsonV4Name

	^ #gtLlmActionMessage
%

!		Instance methods for 'GtLlmActionMessage'

category: 'visiting'
method: GtLlmActionMessage
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmActionMessage: self
%

category: 'as yet unclassified'
method: GtLlmActionMessage
actionModel
	^ (self chat assistant actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
%

category: 'as yet unclassified'
method: GtLlmActionMessage
contentSummary
	^ self action
%

category: 'as yet unclassified'
method: GtLlmActionMessage
gtChatRequestFor: aView
	<gtView>
	<gtLlmMessageView>
	self action = 'Chat' ifFalse: [ ^ aView empty ].
	self isUserRole ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Message';
		priority: 1;
		text: [ self arguments first ]
%

category: 'as yet unclassified'
method: GtLlmActionMessage
gtContentFor: aView
	<gtView>
	<gtLlmMessageView>
	^ aView empty
%

category: 'as yet unclassified'
method: GtLlmActionMessage
gtPromoteToExampleActionFor: anAction
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat assistant actionNamed: self action.
			example := GtLlmAssistantActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
%

category: 'as yet unclassified'
method: GtLlmActionMessage
textBlock
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
%

! Class implementation for 'GtLlmAssistantMessage'

!		Class methods for 'GtLlmAssistantMessage'

category: 'accessing'
classmethod: GtLlmAssistantMessage
defaultRole
	^ 'assistant'
%

category: 'accessing'
classmethod: GtLlmAssistantMessage
leJsonV4Name

	^ #gtLlmAssistantMessage
%

!		Instance methods for 'GtLlmAssistantMessage'

category: 'visiting'
method: GtLlmAssistantMessage
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmAssistantMessage: self
%

! Class implementation for 'GtLlmSystemMessage'

!		Class methods for 'GtLlmSystemMessage'

category: 'accessing'
classmethod: GtLlmSystemMessage
defaultRole
	^ 'system'
%

category: 'accessing'
classmethod: GtLlmSystemMessage
leJsonV4Name

	^ #gtLlmSystemMessage
%

!		Instance methods for 'GtLlmSystemMessage'

category: 'visiting'
method: GtLlmSystemMessage
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmSystemMessage: self
%

! Class implementation for 'GtLlmToolMessage'

!		Class methods for 'GtLlmToolMessage'

category: 'as yet unclassified'
classmethod: GtLlmToolMessage
defaultRole
	^ 'tool'
%

category: 'accessing'
classmethod: GtLlmToolMessage
leJsonV4Name

	^ #gtLlmToolMessage
%

!		Instance methods for 'GtLlmToolMessage'

category: 'visiting'
method: GtLlmToolMessage
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmToolMessage: self
%

category: 'as yet unclassified'
method: GtLlmToolMessage
action
	^ self toolCall humanReadable
%

category: 'as yet unclassified'
method: GtLlmToolMessage
actionModel
	^ self toolCall
%

category: 'as yet unclassified'
method: GtLlmToolMessage
content
	^ self output
%

category: 'as yet unclassified'
method: GtLlmToolMessage
contentText
	^ ''
%

category: 'as yet unclassified'
method: GtLlmToolMessage
gtArgumentsFor: aView
	<gtView>
	<gtLlmMessageView>
	^ aView forward
		title: 'Arguments';
		priority: 5;
		object: [ self toolCall ];
		view: #gtArgumentsFor:
%

category: 'as yet unclassified'
method: GtLlmToolMessage
gtContentFor: aView
	<gtView>
	<gtLlmMessageView>
	^ aView empty
%

category: 'as yet unclassified'
method: GtLlmToolMessage
gtOutputFor: aView
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Output';
		priority: 1;
		text: [ self output ]
%

category: 'accessing'
method: GtLlmToolMessage
output
	^ output
%

category: 'accessing'
method: GtLlmToolMessage
output: anObject
	output := anObject
%

category: 'as yet unclassified'
method: GtLlmToolMessage
serializeResponse
	^ {'type' -> 'function_call_output'.
		'call_id' -> toolCall id.
		'output' -> self output} asDictionary
%

category: 'accessing'
method: GtLlmToolMessage
toolCall
	^ toolCall
%

category: 'accessing'
method: GtLlmToolMessage
toolCall: anObject
	toolCall := anObject
%

! Class implementation for 'GtLlmUserMessage'

!		Class methods for 'GtLlmUserMessage'

category: 'accessing'
classmethod: GtLlmUserMessage
defaultRole
	^ 'user'
%

category: 'accessing'
classmethod: GtLlmUserMessage
leJsonV4Name

	^ #gtLlmUserMessage
%

!		Instance methods for 'GtLlmUserMessage'

category: 'visiting'
method: GtLlmUserMessage
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmUserMessage: self
%

! Class implementation for 'GtOpenAIMessage'

!		Class methods for 'GtOpenAIMessage'

category: 'as yet unclassified'
classmethod: GtOpenAIMessage
from: aDict
	^ self new from: aDict
%

category: 'accessing'
classmethod: GtOpenAIMessage
leJsonV4Name

	^ #gtOpenAIMessage
%

category: 'accessing'
classmethod: GtOpenAIMessage
serializationProperties
	^ {
		#assistant_id -> #assistantId.
		#content -> #content.
		#created_at -> #createdAtString.
		#incomplete_at -> #incompleteAtString.
		#completed_at -> #completedAtString.
		#id -> #idString.
		#metadata -> #metadata.
		#run_id -> #runId.
		#thread_id -> #threadId.
		#role -> #role
	}
%

!		Instance methods for 'GtOpenAIMessage'

category: 'accessing'
method: GtOpenAIMessage
annotations
	(content isKindOf: String) ifTrue: [ ^ GtOpenAIAnnotationsGroup new ].

	^ annotations
		ifNil: [ annotations := GtOpenAIAnnotationsGroup
					withAll: ((content select: [ :aValue | (aValue at: 'type') = 'text' ])
							flatCollect: [ :aValue | 
								((aValue at: 'text') at: 'annotations')
									collect: [ :anAnnotation | 
										(GtOpenAIAnnotation from: anAnnotation)
											client: self client;
											message: self ] ]) ]
%

category: 'accessing'
method: GtOpenAIMessage
assistantId
	^ assistantId
%

category: 'accessing'
method: GtOpenAIMessage
assistantId: anObject
	assistantId := anObject
%

category: 'accessing'
method: GtOpenAIMessage
completedAt
	^ completedAt
%

category: 'accessing'
method: GtOpenAIMessage
completedAt: anObject
	completedAt := anObject
%

category: 'as yet unclassified'
method: GtOpenAIMessage
completedAtString
	^ nil
%

category: 'accessing'
method: GtOpenAIMessage
completedAtString: anObject
	completedAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIMessage
content
	^ content
%

category: 'accessing'
method: GtOpenAIMessage
contentJson
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
%

category: 'accessing'
method: GtOpenAIMessage
contentSummary
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
%

category: 'accessing'
method: GtOpenAIMessage
contentText
	^ (content isKindOf: String)
		ifTrue: [ content ]
		ifFalse: [ ''
				join: (content
						collect: [ :aValue | 
							(aValue at: 'text' ifAbsent: [ nil ])
								ifNil: [ '' ]
								ifNotNil: [ :aTextObject | 
									(aTextObject isKindOf: String)
										ifTrue: [ aTextObject ]
										ifFalse: [ (aTextObject at: 'value') ifNil: [ '' ] ] ] ]) ]
%

category: 'accessing'
method: GtOpenAIMessage
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIMessage
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'as yet unclassified'
method: GtOpenAIMessage
createdAtString
	^ nil
%

category: 'accessing'
method: GtOpenAIMessage
createdAtString: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIMessage
elementClass
	^ self explicitRequirement
%

category: 'accessing'
method: GtOpenAIMessage
gtAnnotationsFor: aView
	<gtView>
	^ aView forward
		title: 'Annotations';
		priority: 2;
		object: [ self annotations ];
		view: #gtAnnotationsFor:
%

category: 'testing'
method: GtOpenAIMessage
hasResponse
	^ self contentText isNotEmpty
%

category: 'accessing'
method: GtOpenAIMessage
hasStep
	^ self step isNotNil
%

category: 'as yet unclassified'
method: GtOpenAIMessage
idString
	^ nil
%

category: 'as yet unclassified'
method: GtOpenAIMessage
idString: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIMessage
incompleteAt
	^ incompleteAt
%

category: 'accessing'
method: GtOpenAIMessage
incompleteAt: anObject
	incompleteAt := anObject
%

category: 'as yet unclassified'
method: GtOpenAIMessage
incompleteAtString
	^ nil
%

category: 'accessing'
method: GtOpenAIMessage
incompleteAtString: anObject
	incompleteAt := self deserializeTime: anObject
%

category: 'testing'
method: GtOpenAIMessage
isAssistantRole
	^ self role = #assistant
%

category: 'testing'
method: GtOpenAIMessage
isFailure
	^ false
%

category: 'as yet unclassified'
method: GtOpenAIMessage
isReady
	^ self incompleteAt isNil or: [ self completedAt ]
%

category: 'testing'
method: GtOpenAIMessage
isSystemRole
	^ self role = #system
%

category: 'testing'
method: GtOpenAIMessage
isUserRole
	^ self role = #user
%

category: 'accessing'
method: GtOpenAIMessage
metadata
	^ metadata
%

category: 'accessing'
method: GtOpenAIMessage
metadata: anObject
	metadata := anObject
%

category: 'accessing'
method: GtOpenAIMessage
role
	^ role
%

category: 'accessing'
method: GtOpenAIMessage
role: anObject
	role := anObject
%

category: 'accessing'
method: GtOpenAIMessage
runId
	^ runId
%

category: 'accessing'
method: GtOpenAIMessage
runId: anObject
	runId := anObject
%

category: 'accessing'
method: GtOpenAIMessage
step
	^ step
%

category: 'accessing'
method: GtOpenAIMessage
step: anObject
	step := anObject
%

category: 'accessing'
method: GtOpenAIMessage
styler
	^ self explicitRequirement
%

category: 'accessing'
method: GtOpenAIMessage
threadId
	^ threadId
%

category: 'accessing'
method: GtOpenAIMessage
threadId: anObject
	threadId := anObject
%

! Class implementation for 'GtOpenAIActionMessage'

!		Class methods for 'GtOpenAIActionMessage'

category: 'accessing'
classmethod: GtOpenAIActionMessage
leJsonV4Name

	^ #gtOpenAIActionMessage
%

!		Instance methods for 'GtOpenAIActionMessage'

category: 'as yet unclassified'
method: GtOpenAIActionMessage
actionModel
	^ (self chat assistant actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
%

category: 'trait-TGtActionMessage'
method: GtOpenAIActionMessage
gtPromoteToExampleActionFor: anAction
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat assistant actionNamed: self action.
			example := GtLlmAssistantActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
%

category: 'as yet unclassified'
method: GtOpenAIActionMessage
textBlock
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
%

! Class implementation for 'GtOpenAIBlogPostMessage'

!		Class methods for 'GtOpenAIBlogPostMessage'

category: 'accessing'
classmethod: GtOpenAIBlogPostMessage
leJsonV4Name

	^ #gtOpenAIBlogPostMessage
%

!		Instance methods for 'GtOpenAIBlogPostMessage'

category: 'trait-TGtActionMessage'
method: GtOpenAIBlogPostMessage
actionModel
	^ (self chat assistant actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
%

category: 'trait-TGtActionMessage'
method: GtOpenAIBlogPostMessage
contentSummary
	^ self action
%

category: 'trait-TGtActionMessage'
method: GtOpenAIBlogPostMessage
gtContentFor: aView
	<gtView>
	<gtLlmMessageView>
	^ aView empty
%

category: 'views'
method: GtOpenAIBlogPostMessage
gtPostFor: aView
	<gtView>
	<gtLlmMessageView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].
	json at: 'Post' ifAbsent: [ ^ aView empty ].
	(json at: 'Post') ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Post';
		priority: 1;
		text: [ json at: 'Post' ]
%

category: 'trait-TGtActionMessage'
method: GtOpenAIBlogPostMessage
textBlock
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
%

! Class implementation for 'GtLlmFunctionToolCall'

!		Class methods for 'GtLlmFunctionToolCall'

category: 'accessing'
classmethod: GtLlmFunctionToolCall
leJsonV4Name

	^ #gtLlmFunctionToolCall
%

category: 'as yet unclassified'
classmethod: GtLlmFunctionToolCall
serializationProperties
	^ {#id -> #id.
		#function -> #function}
%

!		Instance methods for 'GtLlmFunctionToolCall'

category: 'visiting'
method: GtLlmFunctionToolCall
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmFunctionToolCall: self
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
anyArgument
	^ arguments anyOne
%

category: 'accessing'
method: GtLlmFunctionToolCall
arguments
	^ arguments
%

category: 'accessing'
method: GtLlmFunctionToolCall
arguments: anObject
	arguments := anObject
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
function
	^ {'name' -> name.
		'arguments' -> (STONJSON toString: arguments)} asDictionary
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
function: aDict
	name := aDict at: 'name'.
	arguments := aDict at: 'arguments'.

	(arguments isKindOf: String)
		ifTrue: [ arguments := STONJSON fromString: arguments ]
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
gtArgumentsFor: aView
	<gtView>
	arguments ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Arguments';
		priority: 1;
		items: [ self arguments associations ];
		column: 'Name' text: #key;
		column: 'Value' text: #value
%

category: 'views'
method: GtLlmFunctionToolCall
gtToolSourceCodeFor: aView
	<gtView>
	^ aView forward
		title: 'Tool source code';
		priority: 5;
		object: [ tool ];
		view: #gtBlockSourceCodeFor:
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
humanReadable
	^ self name , ' ('
		, (', '
				join: (self arguments associations
						collect: [ :anArgument | anArgument key , ': ' , anArgument value ])), ')'
%

category: 'accessing'
method: GtLlmFunctionToolCall
id
	^ id
%

category: 'accessing'
method: GtLlmFunctionToolCall
id: anObject
	id := anObject
%

category: 'accessing'
method: GtLlmFunctionToolCall
name
	^ name
%

category: 'accessing'
method: GtLlmFunctionToolCall
name: anObject
	name := anObject
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
performedByTool: aTool
	tool := aTool
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
printOn: aStream
	super printOn: aStream.

	self name ifNil: [ ^ self ].

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
%

category: 'as yet unclassified'
method: GtLlmFunctionToolCall
responseInput
	^ {'type' -> 'function_call'.
		'call_id' -> self id.
		'name' -> self name.
		'arguments' -> (STONJSON toString: self arguments)} asDictionary
%

category: 'accessing'
method: GtLlmFunctionToolCall
tool
	^ tool
%

! Class implementation for 'GtLlmTool'

!		Class methods for 'GtLlmTool'

category: 'accessing'
classmethod: GtLlmTool
leJsonV4Name

	^ #gtLlmTool
%

category: 'accessing'
classmethod: GtLlmTool
serializationProperties
	^ {#type -> #type}
%

!		Instance methods for 'GtLlmTool'

category: 'visiting'
method: GtLlmTool
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmTool: self
%

category: 'as yet unclassified'
method: GtLlmTool
defaultType
	^ ''
%

category: 'as yet unclassified'
method: GtLlmTool
description
	^ ''
%

category: 'as yet unclassified'
method: GtLlmTool
functionAnthropic
	^ {'type' -> type.
		'name' -> self name} asDictionary
%

category: 'as yet unclassified'
method: GtLlmTool
functionResponse
	^ {'type' -> type} asDictionary
%

category: 'as yet unclassified'
method: GtLlmTool
initialize
	super initialize.
	
	self type: self defaultType
%

category: 'accessing'
method: GtLlmTool
name
	^ name ifNil: [ type ]
%

category: 'accessing'
method: GtLlmTool
name: anObject
	name := anObject
%

category: 'as yet unclassified'
method: GtLlmTool
parameters
	^ {}
%

category: 'accessing'
method: GtLlmTool
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self type;
		nextPut: $)
%

category: 'accessing'
method: GtLlmTool
type
	^ type
%

category: 'accessing'
method: GtLlmTool
type: anObject
	type := anObject
%

! Class implementation for 'GtLlmFileSearchTool'

!		Class methods for 'GtLlmFileSearchTool'

category: 'accessing'
classmethod: GtLlmFileSearchTool
leJsonV4Name

	^ #gtLlmFileSearchTool
%

!		Instance methods for 'GtLlmFileSearchTool'

category: 'visiting'
method: GtLlmFileSearchTool
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmFileSearchTool: self
%

category: 'as yet unclassified'
method: GtLlmFileSearchTool
defaultType
	^ 'file_search'
%

category: 'as yet unclassified'
method: GtLlmFileSearchTool
description
	^ 'Search the files attached to the chat'
%

category: 'as yet unclassified'
method: GtLlmFileSearchTool
functionResponse
	^ {'type' -> type.
		'vector_store_ids' -> self vectorStoreIds} asDictionary
%

category: 'as yet unclassified'
method: GtLlmFileSearchTool
initialize
	super initialize.
	
	vectorStoreIds := {}
%

category: 'as yet unclassified'
method: GtLlmFileSearchTool
name
	^ 'File search'
%

category: 'as yet unclassified'
method: GtLlmFileSearchTool
parameters
	^ #()
%

category: 'accessing'
method: GtLlmFileSearchTool
vectorStoreIds
	^ vectorStoreIds
%

category: 'accessing'
method: GtLlmFileSearchTool
vectorStoreIds: anObject
	vectorStoreIds := anObject
%

! Class implementation for 'GtLlmFunctionTool'

!		Class methods for 'GtLlmFunctionTool'

category: 'accessing'
classmethod: GtLlmFunctionTool
leJsonV4Name

	^ #gtLlmFunctionTool
%

category: 'as yet unclassified'
classmethod: GtLlmFunctionTool
serializationProperties
	^ {#type -> #type. #function -> #function}
%

!		Instance methods for 'GtLlmFunctionTool'

category: 'visiting'
method: GtLlmFunctionTool
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmFunctionTool: self
%

category: 'accessing'
method: GtLlmFunctionTool
block
	^ block
%

category: 'accessing'
method: GtLlmFunctionTool
block: anObject
	block := anObject
%

category: 'as yet unclassified'
method: GtLlmFunctionTool
defaultType
	^ 'function'
%

category: 'accessing'
method: GtLlmFunctionTool
description
	^ description
%

category: 'accessing'
method: GtLlmFunctionTool
description: anObject
	description := anObject
%

category: 'accessing'
method: GtLlmFunctionTool
function
	^ {'name' -> name.
		'description' -> self description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> parameters.
					'additionalProperties' -> false} asDictionary.
		'strict' -> true} asDictionary
%

category: 'accessing'
method: GtLlmFunctionTool
functionResponse
	^ {'name' -> name.
		'type' -> type.
		'description' -> description.
		'parameters'
			-> {'type' -> 'object'.
					'properties'
						-> (parameters collect: [ :aName | aName -> {'type' -> 'string'} asDictionary ])
								asDictionary.
					'required' -> parameters.
					'additionalProperties' -> false} asDictionary} asDictionary
%

category: 'views'
method: GtLlmFunctionTool
gtBlockSourceCodeFor: aView
	<gtView>
	^ aView forward
		title: 'Source code';
		object: [ block ];
		view: #gtSourceCodeFor:
%

category: 'as yet unclassified'
method: GtLlmFunctionTool
gtMethodFor: aView
	<gtView>
	self method ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Method';
		priority: 2;
		object: [ self method ];
		view: #gtSourceCodeFor:
%

category: 'as yet unclassified'
method: GtLlmFunctionTool
initialize
	super initialize.

	name := ''.
	parameters := {}.
	description := ''
%

category: 'as yet unclassified'
method: GtLlmFunctionTool
method
	| split class methodName |
	name ifNil: [ ^ nil ].

	split := '_' split: name.
	class := split first asClassIfAbsent: [ ^ nil ].
	methodName := ':' join: split allButFirst.
	^ [ class >> methodName asSymbol ] on: Error do: [ nil ]
%

category: 'accessing'
method: GtLlmFunctionTool
parameters
	^ parameters
%

category: 'accessing'
method: GtLlmFunctionTool
parameters: anObject
	parameters := anObject
%

category: 'as yet unclassified'
method: GtLlmFunctionTool
performToolCall: aGtLlmFunctionToolCall
	| result |
	self
		assert: block isNotNil
		description: [ 'Trying to call a function without a block' ].
	"Commented due to Gemstone:
	(GtLlmFunctionCallAboutToBePerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	result := block value: aGtLlmFunctionToolCall.
	aGtLlmFunctionToolCall performedByTool: self.
	"Commented due to Gemstone:
	(GtLlmFunctionCallPerformedSignal new
		tool: self;
		functionCall: aGtLlmFunctionToolCall) emit."
	^ result
%

! Class implementation for 'GtLlmFunctionToolWithProtocol'

!		Class methods for 'GtLlmFunctionToolWithProtocol'

category: 'accessing'
classmethod: GtLlmFunctionToolWithProtocol
leJsonV4Name

	^ #gtLlmFunctionToolWithProtocol
%

!		Instance methods for 'GtLlmFunctionToolWithProtocol'

category: 'as yet unclassified'
method: GtLlmFunctionToolWithProtocol
block: aBlock
	block := [ :aFunctionCall | 
		STONJSON
			toString: ([ {'type' -> 'result'.
					'value' -> (aBlock cull: aFunctionCall) asString} asDictionary ]
					on: Error
					do: [ :e | 
						{'type' -> 'error'.
							'error' -> e asString} asDictionary ]) ]
%

category: 'as yet unclassified'
method: GtLlmFunctionToolWithProtocol
description
	^ description, '

', self protocolDescription
%

category: 'as yet unclassified'
method: GtLlmFunctionToolWithProtocol
protocolDescription
	^ 'On success, an object of the form `{"type": "result", "value": "... result ... "}` will be returned. On error, an object of the form `{"type": "error", "error": "... error message ... "}` will be returned.'
%

! Class implementation for 'GtOllamaEmbedding'

!		Class methods for 'GtOllamaEmbedding'

category: 'accessing'
classmethod: GtOllamaEmbedding
leJsonV4Name

	^ #gtOllamaEmbedding
%

category: 'accessing'
classmethod: GtOllamaEmbedding
serializationProperties
	^ {#embedding -> #embedding}
%

!		Instance methods for 'GtOllamaEmbedding'

category: 'accessing'
method: GtOllamaEmbedding
embedding
	^ embedding
%

category: 'accessing'
method: GtOllamaEmbedding
embedding: anObject
	embedding := anObject
%

category: 'accessing'
method: GtOllamaEmbedding
size
	^ self embedding size
%

! Class implementation for 'GtOllamaModel'

!		Class methods for 'GtOllamaModel'

category: 'accessing'
classmethod: GtOllamaModel
leJsonV4Name

	^ #gtOllamaModel
%

category: 'accessing'
classmethod: GtOllamaModel
serializationProperties
	^ {#name -> #name.
		#model -> #model.
		#modified_at -> #modifiedAt.
		#size -> #size.
		#digest -> #digest.
		#details -> #details}
%

!		Instance methods for 'GtOllamaModel'

category: 'accessing'
method: GtOllamaModel
details
	^ details
%

category: 'accessing'
method: GtOllamaModel
details: anObject
	details := anObject
%

category: 'accessing'
method: GtOllamaModel
digest
	^ digest
%

category: 'accessing'
method: GtOllamaModel
digest: anObject
	digest := anObject
%

category: 'accessing'
method: GtOllamaModel
gtPushModelActionFor: anAction
	<gtAction>
	^ anAction button
		label: 'Publish';
		action: [ :aButton | aButton phlow spawnObject: (self client pushModel: self name) ]
%

category: 'accessing'
method: GtOllamaModel
model
	^ model
%

category: 'accessing'
method: GtOllamaModel
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaModel
modifiedAt
	^ modifiedAt
%

category: 'accessing'
method: GtOllamaModel
modifiedAt: anObject
	modifiedAt := DateAndTime fromString: anObject
%

category: 'accessing'
method: GtOllamaModel
name
	^ name
%

category: 'accessing'
method: GtOllamaModel
name: anObject
	name := anObject
%

category: 'accessing'
method: GtOllamaModel
size
	^ size
%

category: 'accessing'
method: GtOllamaModel
size: anObject
	size := anObject
%

! Class implementation for 'GtOllamaModelInformation'

!		Class methods for 'GtOllamaModelInformation'

category: 'accessing'
classmethod: GtOllamaModelInformation
leJsonV4Name

	^ #gtOllamaModelInformation
%

category: 'accessing'
classmethod: GtOllamaModelInformation
serializationProperties
	^ {#modelfile -> #modelfile.
		#parameters -> #parameters.
		#template -> #template.
		#details -> #details.
		#model_info -> #modelInfo.
		#license -> #license
	}
%

!		Instance methods for 'GtOllamaModelInformation'

category: 'accessing'
method: GtOllamaModelInformation
details
	^ details
%

category: 'accessing'
method: GtOllamaModelInformation
details: anObject
	details := anObject
%

category: 'accessing'
method: GtOllamaModelInformation
gtDetailsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 8;
		items: [ self details associations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
%

category: 'accessing'
method: GtOllamaModelInformation
gtLicenseFor: aView
	<gtView>
	^ aView textEditor
		title: 'Modelfile';
		priority: 2;
		text: [ self modelfile ]
%

category: 'accessing'
method: GtOllamaModelInformation
gtModelInfoFor: aView
	<gtView>
	^ aView columnedList
		title: 'Model info';
		priority: 1;
		items: [ self modelInfo associations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
%

category: 'accessing'
method: GtOllamaModelInformation
gtParametersFor: aView
	<gtView>
	^ aView columnedList
		title: 'Parameters';
		priority: 8;
		items: [ self parameterAssociations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		send: #value
%

category: 'accessing'
method: GtOllamaModelInformation
license
	^ license
%

category: 'accessing'
method: GtOllamaModelInformation
license: anObject
	license := anObject
%

category: 'accessing'
method: GtOllamaModelInformation
modelfile
	^ modelfile
%

category: 'accessing'
method: GtOllamaModelInformation
modelfile: anObject
	modelfile := anObject
%

category: 'accessing'
method: GtOllamaModelInformation
modelInfo
	^ modelInfo
%

category: 'accessing'
method: GtOllamaModelInformation
modelInfo: anObject
	modelInfo := anObject
%

category: 'accessing'
method: GtOllamaModelInformation
parameterAssociations
	^ ((Character linefeed split: self parameters)
		collect: [ :aLine | 
			| keyAndValue |
			keyAndValue := aLine substrings.
			Association key: keyAndValue first value: keyAndValue second ])
%

category: 'accessing'
method: GtOllamaModelInformation
parameters
	^ parameters
%

category: 'accessing'
method: GtOllamaModelInformation
parameters: anObject
	parameters := anObject
%

category: 'accessing'
method: GtOllamaModelInformation
template
	^ template
%

category: 'accessing'
method: GtOllamaModelInformation
template: anObject
	template := anObject
%

! Class implementation for 'GtOllamaResponseMessage'

!		Class methods for 'GtOllamaResponseMessage'

category: 'accessing'
classmethod: GtOllamaResponseMessage
leJsonV4Name

	^ #gtOllamaResponseMessage
%

!		Instance methods for 'GtOllamaResponseMessage'

category: 'accessing'
method: GtOllamaResponseMessage
content

	^ '' join: (rawData collect: [ :each | each at: 'response' ])
%

category: 'ui'
method: GtOllamaResponseMessage
gtResponseFor: aView
	<gtView>

	rawData ifNil: [ ^ aView empty ].
	^ aView text
		title: 'Response';
		priority: 5;
		text: [ self content ]
%

! Class implementation for 'GtOllamaRunningModel'

!		Class methods for 'GtOllamaRunningModel'

category: 'accessing'
classmethod: GtOllamaRunningModel
leJsonV4Name

	^ #gtOllamaRunningModel
%

category: 'accessing'
classmethod: GtOllamaRunningModel
serializationProperties
	^ {#name -> #name.
		#model -> #model.
		#expires_at -> #expiresAt.
		#size -> #size.
		#size_vram -> #sizeVram.
		#digest -> #digest.
		#details -> #details}
%

!		Instance methods for 'GtOllamaRunningModel'

category: 'accessing'
method: GtOllamaRunningModel
details
	^ details
%

category: 'accessing'
method: GtOllamaRunningModel
details: anObject
	details := anObject
%

category: 'accessing'
method: GtOllamaRunningModel
digest
	^ digest
%

category: 'accessing'
method: GtOllamaRunningModel
digest: anObject
	digest := anObject
%

category: 'accessing'
method: GtOllamaRunningModel
expiresAt
	^ expiresAt
%

category: 'accessing'
method: GtOllamaRunningModel
expiresAt: anObject
	expiresAt := DateAndTime fromString: anObject
%

category: 'accessing'
method: GtOllamaRunningModel
model
	^ model
%

category: 'accessing'
method: GtOllamaRunningModel
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaRunningModel
name
	^ name
%

category: 'accessing'
method: GtOllamaRunningModel
name: anObject
	name := anObject
%

category: 'accessing'
method: GtOllamaRunningModel
size
	^ size
%

category: 'accessing'
method: GtOllamaRunningModel
size: anObject
	size := anObject
%

category: 'accessing'
method: GtOllamaRunningModel
sizeVram
	^ sizeVram
%

category: 'accessing'
method: GtOllamaRunningModel
sizeVram: anObject
	sizeVram := anObject
%

! Class implementation for 'GtOllamaStatusSteps'

!		Class methods for 'GtOllamaStatusSteps'

category: 'accessing'
classmethod: GtOllamaStatusSteps
from: anArray
	^ self new steps: (anArray collect: [ :aDict | aDict at: 'status' ])
%

category: 'accessing'
classmethod: GtOllamaStatusSteps
leJsonV4Name

	^ #gtOllamaStatusSteps
%

!		Instance methods for 'GtOllamaStatusSteps'

category: 'accessing'
method: GtOllamaStatusSteps
gtStepsFor: aView
	<gtView>
	^ aView list
		title: 'Steps';
		priority: 1;
		items: [ self steps ]
%

category: 'accessing'
method: GtOllamaStatusSteps
steps
	^ steps
%

category: 'accessing'
method: GtOllamaStatusSteps
steps: anObject
	steps := anObject
%

! Class implementation for 'GtOllamaThreadMessage'

!		Class methods for 'GtOllamaThreadMessage'

category: 'accessing'
classmethod: GtOllamaThreadMessage
leJsonV4Name

	^ #gtOllamaThreadMessage
%

category: 'accessing'
classmethod: GtOllamaThreadMessage
serializationProperties
	^ {
		#content -> #content.
		#message -> #message.
		#role -> #role.
		#eval_count -> #evalCount.
		#prompt_eval_duration->#promptEvalDuration.
		#model -> #model.
		#created_at -> #createdAt.
		#eval_duration -> #evalDuration.
		#total_duration -> #totalDuration.
		#load_duration -> #loadDuration.
		#done_reason -> #doneReason.
		#prompt_eval_count -> #promptEvalCount
	}
%

!		Instance methods for 'GtOllamaThreadMessage'

category: 'accessing'
method: GtOllamaThreadMessage
content
	^ self message at: 'content'
%

category: 'as yet unclassified'
method: GtOllamaThreadMessage
content: aString
%

category: 'accessing'
method: GtOllamaThreadMessage
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOllamaThreadMessage
createdAt: anObject
	createdAt := DateAndTime fromString: anObject
%

category: 'accessing'
method: GtOllamaThreadMessage
doneReason
	^ doneReason
%

category: 'accessing'
method: GtOllamaThreadMessage
doneReason: anObject
	doneReason := anObject
%

category: 'accessing'
method: GtOllamaThreadMessage
evalCount
	^ evalCount
%

category: 'accessing'
method: GtOllamaThreadMessage
evalCount: anObject
	evalCount := anObject
%

category: 'accessing'
method: GtOllamaThreadMessage
evalDuration
	^ evalDuration
%

category: 'accessing'
method: GtOllamaThreadMessage
evalDuration: anObject
	evalDuration := anObject ifNotNil: [ :aValue | aValue nanoSeconds ]
%

category: 'accessing'
method: GtOllamaThreadMessage
loadDuration
	^ loadDuration
%

category: 'accessing'
method: GtOllamaThreadMessage
loadDuration: anObject
	loadDuration := anObject nanoSeconds
%

category: 'accessing'
method: GtOllamaThreadMessage
message
	^ message
%

category: 'accessing'
method: GtOllamaThreadMessage
message: anObject
	message := anObject
%

category: 'accessing'
method: GtOllamaThreadMessage
model
	^ model
%

category: 'accessing'
method: GtOllamaThreadMessage
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOllamaThreadMessage
promptEvalCount
	^ promptEvalCount
%

category: 'accessing'
method: GtOllamaThreadMessage
promptEvalCount: anObject
	promptEvalCount := anObject
%

category: 'accessing'
method: GtOllamaThreadMessage
promptEvalDuration
	^ promptEvalDuration
%

category: 'accessing'
method: GtOllamaThreadMessage
promptEvalDuration: anObject
	promptEvalDuration := anObject ifNotNil: [ :timestamp | timestamp nanoSeconds ]
%

category: 'accessing'
method: GtOllamaThreadMessage
role
	^ 'assistant'
%

category: 'as yet unclassified'
method: GtOllamaThreadMessage
role: anArgument
	"we ignore the role"
%

category: 'as yet unclassified'
method: GtOllamaThreadMessage
toolCalls
	^ (self message at: 'tool_calls' ifAbsent: [ {} ])
		collect: [ :aDict | GtLlmFunctionToolCall from: aDict ]
%

category: 'accessing'
method: GtOllamaThreadMessage
totalDuration
	^ totalDuration
%

category: 'accessing'
method: GtOllamaThreadMessage
totalDuration: anObject
	totalDuration := anObject nanoSeconds
%

! Class implementation for 'GtOpenAIAnnotation'

!		Class methods for 'GtOpenAIAnnotation'

category: 'accessing'
classmethod: GtOpenAIAnnotation
leJsonV4Name

	^ #gtOpenAIAnnotation
%

category: 'accessing'
classmethod: GtOpenAIAnnotation
serializationProperties
	^ {
		#text -> #text.
		#type -> #type.
		#start_index -> #startIndex.
		#end_index -> #endIndex.
		#file_citation -> #fileCitation
	}
%

!		Instance methods for 'GtOpenAIAnnotation'

category: 'accessing'
method: GtOpenAIAnnotation
client: aClient
	super client: aClient.

	fileCitation client: self client
%

category: 'accessing'
method: GtOpenAIAnnotation
endIndex
	^ endIndex
%

category: 'accessing'
method: GtOpenAIAnnotation
endIndex: anObject
	endIndex := anObject
%

category: 'accessing'
method: GtOpenAIAnnotation
file
	^ self fileCitation file
%

category: 'accessing'
method: GtOpenAIAnnotation
fileCitation
	^ fileCitation
%

category: 'accessing'
method: GtOpenAIAnnotation
fileCitation: anObject
	fileCitation := (GtOpenAIFileCitation from: anObject)
			client: self client;
			annotation: self
%

category: 'accessing'
method: GtOpenAIAnnotation
message
	^ message
%

category: 'accessing'
method: GtOpenAIAnnotation
message: anObject
	message := anObject
%

category: 'as yet unclassified'
method: GtOpenAIAnnotation
quote
	self fileCitation quote ifNotNil: [ :aQuote | ^ aQuote].
	
	^ self file contents contents copyFrom: self startIndex to: self endIndex
%

category: 'accessing'
method: GtOpenAIAnnotation
startIndex
	^ startIndex
%

category: 'accessing'
method: GtOpenAIAnnotation
startIndex: anObject
	startIndex := anObject
%

category: 'accessing'
method: GtOpenAIAnnotation
text
	^ text
%

category: 'accessing'
method: GtOpenAIAnnotation
text: anObject
	text := anObject
%

category: 'accessing'
method: GtOpenAIAnnotation
type
	^ type
%

category: 'accessing'
method: GtOpenAIAnnotation
type: anObject
	type := anObject
%

! Class implementation for 'GtOpenAIAssistant'

!		Class methods for 'GtOpenAIAssistant'

category: 'accessing'
classmethod: GtOpenAIAssistant
leJsonV4Name

	^ #gtOpenAIAssistant
%

category: 'accessing'
classmethod: GtOpenAIAssistant
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#name -> #name.
		#description -> #description.
		#model -> #model.
		#instructions -> #instructions.
		#tools -> #tools.
		#tool_resources -> #toolResources}
%

!		Instance methods for 'GtOpenAIAssistant'

category: 'accessing'
method: GtOpenAIAssistant
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIAssistant
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIAssistant
description
	^ description
%

category: 'accessing'
method: GtOpenAIAssistant
description: anObject
	description := anObject
%

category: 'accessing'
method: GtOpenAIAssistant
gtToolsFor: aView
	<gtView>
	^ aView list
		title: 'Tools';
		priority: 2;
		items: [ self tools ];
		itemText: #type
%

category: 'accessing'
method: GtOpenAIAssistant
id
	^ id
%

category: 'accessing'
method: GtOpenAIAssistant
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIAssistant
instructions
	^ instructions
%

category: 'accessing'
method: GtOpenAIAssistant
instructions: anObject
	instructions := anObject
%

category: 'accessing'
method: GtOpenAIAssistant
model
	^ model
%

category: 'accessing'
method: GtOpenAIAssistant
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIAssistant
name
	^ name
%

category: 'accessing'
method: GtOpenAIAssistant
name: anObject
	name := anObject
%

category: 'accessing'
method: GtOpenAIAssistant
serialize
	| serialized |
	serialized := super serialize.
	serialized at: #tools put: ((serialized at: #tools) collect: #serialize).
	^ serialized
%

category: 'accessing'
method: GtOpenAIAssistant
toolResources
	^ toolResources
%

category: 'accessing'
method: GtOpenAIAssistant
toolResources: anObject
	toolResources := anObject
%

category: 'accessing'
method: GtOpenAIAssistant
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIAssistant
tools: anObject
	tools := anObject collect: [ :aValue | GtLlmTool from: aValue ]
%

! Class implementation for 'GtOpenAIAssistantFile'

!		Class methods for 'GtOpenAIAssistantFile'

category: 'accessing'
classmethod: GtOpenAIAssistantFile
leJsonV4Name

	^ #gtOpenAIAssistantFile
%

category: 'accessing'
classmethod: GtOpenAIAssistantFile
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#assistant_id -> #assistantId}
%

!		Instance methods for 'GtOpenAIAssistantFile'

category: 'accessing'
method: GtOpenAIAssistantFile
assistantId
	^ assistantId
%

category: 'accessing'
method: GtOpenAIAssistantFile
assistantId: anObject
	assistantId := anObject
%

category: 'accessing'
method: GtOpenAIAssistantFile
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIAssistantFile
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIAssistantFile
id
	^ id
%

category: 'accessing'
method: GtOpenAIAssistantFile
id: anObject
	id := anObject
%

! Class implementation for 'GtOpenAIChatCompletion'

!		Class methods for 'GtOpenAIChatCompletion'

category: 'accessing'
classmethod: GtOpenAIChatCompletion
leJsonV4Name

	^ #gtOpenAIChatCompletion
%

category: 'accessing'
classmethod: GtOpenAIChatCompletion
serializationProperties
	^ {#id -> #id.
		#created -> #created.
		#model -> #model.
		#choices -> #choices.
		#usage -> #usage.
		#system_fingerprint -> #systemFingerprint}
%

!		Instance methods for 'GtOpenAIChatCompletion'

category: 'accessing'
method: GtOpenAIChatCompletion
choices
	^ choices
%

category: 'accessing'
method: GtOpenAIChatCompletion
choices: anObject
	choices := anObject
			collect: [ :aChoice | GtOpenAIChatCompletionChoice from: aChoice ]
%

category: 'accessing'
method: GtOpenAIChatCompletion
created
	^ created
%

category: 'accessing'
method: GtOpenAIChatCompletion
created: anObject
	created := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIChatCompletion
gtChoicesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Choices';
		priority: 1;
		items: [ self choices ];
		column: 'Index' text: #index width: 40;
		column: 'Message' text: [ :aChoice | aChoice message content ];
		column: 'Finish reason' text: #finishReason width: 80
%

category: 'accessing'
method: GtOpenAIChatCompletion
id
	^ id
%

category: 'accessing'
method: GtOpenAIChatCompletion
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIChatCompletion
model
	^ model
%

category: 'accessing'
method: GtOpenAIChatCompletion
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIChatCompletion
systemFingerprint
	^ systemFingerprint
%

category: 'accessing'
method: GtOpenAIChatCompletion
systemFingerprint: anObject
	systemFingerprint := anObject
%

category: 'accessing'
method: GtOpenAIChatCompletion
usage
	^ usage
%

category: 'accessing'
method: GtOpenAIChatCompletion
usage: anObject
	usage := GtOpenAIUsage from: anObject
%

! Class implementation for 'GtOpenAIChatCompletionChoice'

!		Class methods for 'GtOpenAIChatCompletionChoice'

category: 'accessing'
classmethod: GtOpenAIChatCompletionChoice
leJsonV4Name

	^ #gtOpenAIChatCompletionChoice
%

category: 'accessing'
classmethod: GtOpenAIChatCompletionChoice
serializationProperties
	^ {#finish_reason -> #finishReason.
		#index -> #index.
		#logprobs -> #logProbs.
		#message -> #message}
%

!		Instance methods for 'GtOpenAIChatCompletionChoice'

category: 'accessing'
method: GtOpenAIChatCompletionChoice
finishReason
	^ finishReason
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
finishReason: anObject
	finishReason := anObject
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
gtMessageFor: aView
	<gtView>
	^ aView forward
		title: 'Message';
		priority: 1;
		object: [ self message ];
		view: #gtContentFor:
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
index
	^ index
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
index: anObject
	index := anObject
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
logProbs
	^ logProbs
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
logProbs: anObject
	logProbs := anObject
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
message
	^ message
%

category: 'accessing'
method: GtOpenAIChatCompletionChoice
message: anObject
	message := GtLlmChatMessage from: anObject
%

! Class implementation for 'GtOpenAIDeletion'

!		Class methods for 'GtOpenAIDeletion'

category: 'accessing'
classmethod: GtOpenAIDeletion
leJsonV4Name

	^ #gtOpenAIDeletion
%

category: 'accessing'
classmethod: GtOpenAIDeletion
serializationProperties
	^ {#id -> #id.
		#object -> #object.
		#deleted -> #isDeleted}
%

!		Instance methods for 'GtOpenAIDeletion'

category: 'accessing'
method: GtOpenAIDeletion
id
	^ id
%

category: 'accessing'
method: GtOpenAIDeletion
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIDeletion
isDeleted
	^ isDeleted
%

category: 'accessing'
method: GtOpenAIDeletion
isDeleted: anObject
	isDeleted := anObject
%

category: 'accessing'
method: GtOpenAIDeletion
object
	^ object
%

category: 'accessing'
method: GtOpenAIDeletion
object: anObject
	object := anObject
%

! Class implementation for 'GtOpenAIEmbedding'

!		Class methods for 'GtOpenAIEmbedding'

category: 'accessing'
classmethod: GtOpenAIEmbedding
from: anArray
	^ self new
		rawData: anArray;
		embedding: (anArray collect: [ :aNumber | aNumber ] as: OrderedCollection)
%

category: 'accessing'
classmethod: GtOpenAIEmbedding
leJsonV4Name

	^ #gtOpenAIEmbedding
%

!		Instance methods for 'GtOpenAIEmbedding'

category: 'accessing'
method: GtOpenAIEmbedding
embedding
	^ embedding
%

category: 'accessing'
method: GtOpenAIEmbedding
embedding: anObject
	embedding := anObject
%

category: 'accessing'
method: GtOpenAIEmbedding
serialize
	^ self embedding
%

category: 'accessing'
method: GtOpenAIEmbedding
size
	^ self embedding size
%

! Class implementation for 'GtOpenAIFile'

!		Class methods for 'GtOpenAIFile'

category: 'accessing'
classmethod: GtOpenAIFile
leJsonV4Name

	^ #gtOpenAIFile
%

category: 'accessing'
classmethod: GtOpenAIFile
serializationProperties
	^ {#id -> #id.
		#purpose -> #purpose.
		#filename -> #filename.
		#bytes -> #bytes.
		#created_at -> #createdAt.
		#status -> #status.
		#status_details -> #statusDetails}
%

!		Instance methods for 'GtOpenAIFile'

category: 'accessing'
method: GtOpenAIFile
bytes
	^ bytes
%

category: 'accessing'
method: GtOpenAIFile
bytes: anObject
	bytes := anObject
%

category: 'as yet unclassified'
method: GtOpenAIFile
contents
	^ (FileSystem memory / self filename) ensureCreateFile
		binaryWriteStreamDo: [ :aStream | aStream nextPutAll: (self client getFileContents: self id) ];
		yourself
%

category: 'accessing'
method: GtOpenAIFile
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIFile
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIFile
filename
	^ filename
%

category: 'accessing'
method: GtOpenAIFile
filename: anObject
	filename := anObject
%

category: 'accessing'
method: GtOpenAIFile
id
	^ id
%

category: 'accessing'
method: GtOpenAIFile
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIFile
isAssistantsOutput
	^ self purpose = 'assistants-output'
%

category: 'accessing'
method: GtOpenAIFile
isError
	^ self status = 'error'
%

category: 'accessing'
method: GtOpenAIFile
isFinetuningResults
	^ self purpose = 'fine-tune-results'
%

category: 'accessing'
method: GtOpenAIFile
isForAssistants
	^ self purpose = 'assistants'
%

category: 'accessing'
method: GtOpenAIFile
isForFinetuning
	^ self purpose = 'fine-tune'
%

category: 'accessing'
method: GtOpenAIFile
isProcessed
	^ self status = 'processed'
%

category: 'accessing'
method: GtOpenAIFile
isUploaded
	^ self status = 'uploaded'
%

category: 'accessing'
method: GtOpenAIFile
purpose
	^ purpose
%

category: 'accessing'
method: GtOpenAIFile
purpose: anObject
	purpose := anObject
%

category: 'accessing'
method: GtOpenAIFile
status
	^ status
%

category: 'accessing'
method: GtOpenAIFile
status: anObject
	status := anObject
%

category: 'accessing'
method: GtOpenAIFile
statusDetails
	^ statusDetails
%

category: 'accessing'
method: GtOpenAIFile
statusDetails: anObject
	statusDetails := anObject
%

! Class implementation for 'GtOpenAIFileCitation'

!		Class methods for 'GtOpenAIFileCitation'

category: 'accessing'
classmethod: GtOpenAIFileCitation
leJsonV4Name

	^ #gtOpenAIFileCitation
%

category: 'accessing'
classmethod: GtOpenAIFileCitation
serializationProperties
	^ {#file_id -> #fileId.
		#quote -> #quote}
%

!		Instance methods for 'GtOpenAIFileCitation'

category: 'accessing'
method: GtOpenAIFileCitation
annotation
	^ annotation
%

category: 'accessing'
method: GtOpenAIFileCitation
annotation: anObject
	annotation := anObject
%

category: 'accessing'
method: GtOpenAIFileCitation
file
	^ self fileId
		ifEmpty: [ nil ]
		ifNotEmpty: [ self annotation message chat provider getApiFile: self fileId ]
%

category: 'accessing'
method: GtOpenAIFileCitation
fileId
	^ fileId
%

category: 'accessing'
method: GtOpenAIFileCitation
fileId: anObject
	fileId := anObject
%

category: 'accessing'
method: GtOpenAIFileCitation
quote
	^ quote
%

category: 'accessing'
method: GtOpenAIFileCitation
quote: anObject
	quote := anObject
%

! Class implementation for 'GtOpenAIFineTuningCheckpoint'

!		Class methods for 'GtOpenAIFineTuningCheckpoint'

category: 'accessing'
classmethod: GtOpenAIFineTuningCheckpoint
leJsonV4Name

	^ #gtOpenAIFineTuningCheckpoint
%

category: 'accessing'
classmethod: GtOpenAIFineTuningCheckpoint
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#fine_tuned_model_checkpoint -> #fineTunedModelCheckpoint.
		#metrics -> #metrics.
		#fine_tuning_job_id -> #fineTuningJobId.
		#step_number -> #stepNumber}
%

!		Instance methods for 'GtOpenAIFineTuningCheckpoint'

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
fineTunedModelCheckpoint
	^ fineTunedModelCheckpoint
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
fineTunedModelCheckpoint: anObject
	fineTunedModelCheckpoint := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
fineTuningJobId
	^ fineTuningJobId
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
fineTuningJobId: anObject
	fineTuningJobId := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
id
	^ id
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
metrics
	^ metrics
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
metrics: anObject
	metrics := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
stepNumber
	^ stepNumber
%

category: 'accessing'
method: GtOpenAIFineTuningCheckpoint
stepNumber: anObject
	stepNumber := anObject
%

! Class implementation for 'GtOpenAIFineTuningEvent'

!		Class methods for 'GtOpenAIFineTuningEvent'

category: 'accessing'
classmethod: GtOpenAIFineTuningEvent
leJsonV4Name

	^ #gtOpenAIFineTuningEvent
%

category: 'accessing'
classmethod: GtOpenAIFineTuningEvent
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#level -> #level.
		#message -> #message.
		#data -> #data.
		#type -> #type}
%

!		Instance methods for 'GtOpenAIFineTuningEvent'

category: 'accessing'
method: GtOpenAIFineTuningEvent
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
data
	^ data
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
data: anObject
	data := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
id
	^ id
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
level
	^ level
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
level: anObject
	level := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
message
	^ message
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
message: anObject
	message := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
type
	^ type
%

category: 'accessing'
method: GtOpenAIFineTuningEvent
type: anObject
	type := anObject
%

! Class implementation for 'GtOpenAIFineTuningJob'

!		Class methods for 'GtOpenAIFineTuningJob'

category: 'accessing'
classmethod: GtOpenAIFineTuningJob
leJsonV4Name

	^ #gtOpenAIFineTuningJob
%

category: 'accessing'
classmethod: GtOpenAIFineTuningJob
serializationProperties
	^ {#object -> #object.
		#id -> #id.
		#model -> #model.
		#created_at -> #createdAt.
		#finished_at -> #finishedAt.
		#fine_tuned_model -> #fineTunedModel.
		#organization_id -> #organizationId.
		#result_files -> #resultFiles.
		#status -> #status.
		#validation_file -> #validationFile.
		#training_file -> #trainingFile.
		#estimated_finish -> #estimatedFinish}
%

!		Instance methods for 'GtOpenAIFineTuningJob'

category: 'accessing'
method: GtOpenAIFineTuningJob
checkpoints
	^ self client getFineTuningCheckpointsForJob: self id
%

category: 'accessing'
method: GtOpenAIFineTuningJob
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIFineTuningJob
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
currentTrainingTime
	^ self totalTrainingTime
		ifNil: [ ^ DateAndTime now - (DateAndTime fromUnixTime: self createdAt) ]
%

category: 'accessing'
method: GtOpenAIFineTuningJob
estimatedFinish
	^ estimatedFinish
%

category: 'accessing'
method: GtOpenAIFineTuningJob
estimatedFinish: anObject
	estimatedFinish := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
events
	^ self client getFineTuningEventsForJob: self id
%

category: 'accessing'
method: GtOpenAIFineTuningJob
fineTunedModel
	^ fineTunedModel
%

category: 'accessing'
method: GtOpenAIFineTuningJob
fineTunedModel: anObject
	fineTunedModel := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
finishedAt
	^ finishedAt
%

category: 'accessing'
method: GtOpenAIFineTuningJob
finishedAt: anObject
	finishedAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
gtActionChatFor: anAction
	<gtAction>
	self fineTunedModel ifNil: [ ^ anAction noAction ].

	^ anAction button
		label: 'Chat';
		priority: 1;
		action: [ :aButton | 
			aButton phlow
				spawnObject: (GtLlmChat new
						provider: (GtOpenAIProvider withApiKeyFromFile model: self fineTunedModel)) ]
%

category: 'accessing'
method: GtOpenAIFineTuningJob
gtCheckpointsFor: aView
	<gtView>
	^ aView forward
		title: 'Checkpoints';
		priority: 2;
		object: [ self checkpoints ];
		view: #gtCheckpointsFor:
%

category: 'accessing'
method: GtOpenAIFineTuningJob
gtEventsFor: aView
	<gtView>
	"cannot be forward due to update button"
	^ aView columnedList
		title: 'Events';
		priority: 1;
		items: [ self events ];
		column: 'Level' text: #level weight: 0.5;
		column: 'Message' text: #message weight: 2;
		column: 'Time' text: #createdAt weight: 0.5;
		actionUpdateButton
%

category: 'accessing'
method: GtOpenAIFineTuningJob
id
	^ id
%

category: 'accessing'
method: GtOpenAIFineTuningJob
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
model
	^ model
%

category: 'accessing'
method: GtOpenAIFineTuningJob
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
object
	^ object
%

category: 'accessing'
method: GtOpenAIFineTuningJob
object: anObject
	object := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
organizationId
	^ organizationId
%

category: 'accessing'
method: GtOpenAIFineTuningJob
organizationId: anObject
	organizationId := anObject
%

category: 'as yet unclassified'
method: GtOpenAIFineTuningJob
refresh
	self from: (client getFineTuningJob: self id) serialize
%

category: 'accessing'
method: GtOpenAIFineTuningJob
resultFiles
	^ resultFiles
%

category: 'accessing'
method: GtOpenAIFineTuningJob
resultFiles: anObject
	resultFiles := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
status
	^ status
%

category: 'accessing'
method: GtOpenAIFineTuningJob
status: anObject
	status := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
totalTrainingTime
	^ self finishedAt
		ifNil: [ nil ]
		ifNotNil: [ (DateAndTime fromUnixTime: self finishedAt)
				- (DateAndTime fromUnixTime: self createdAt) ]
%

category: 'accessing'
method: GtOpenAIFineTuningJob
trainingFile
	^ trainingFile
%

category: 'accessing'
method: GtOpenAIFineTuningJob
trainingFile: anObject
	trainingFile := anObject
%

category: 'accessing'
method: GtOpenAIFineTuningJob
validationFile
	^ validationFile
%

category: 'accessing'
method: GtOpenAIFineTuningJob
validationFile: anObject
	validationFile := anObject
%

! Class implementation for 'GtOpenAIModel'

!		Class methods for 'GtOpenAIModel'

category: 'accessing'
classmethod: GtOpenAIModel
leJsonV4Name

	^ #gtOpenAIModel
%

category: 'accessing'
classmethod: GtOpenAIModel
serializationProperties
	^ {#created -> #created.
		#id -> #id.
		#object -> #object.
		#owned_by -> #ownedBy}
%

!		Instance methods for 'GtOpenAIModel'

category: 'accessing'
method: GtOpenAIModel
created
	^ created
%

category: 'accessing'
method: GtOpenAIModel
created: anObject
	created := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIModel
id
	^ id
%

category: 'accessing'
method: GtOpenAIModel
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIModel
object
	^ object
%

category: 'accessing'
method: GtOpenAIModel
object: anObject
	object := anObject
%

category: 'accessing'
method: GtOpenAIModel
ownedBy
	^ ownedBy
%

category: 'accessing'
method: GtOpenAIModel
ownedBy: anObject
	ownedBy := anObject
%

! Class implementation for 'GtOpenAIResponse'

!		Class methods for 'GtOpenAIResponse'

category: 'accessing'
classmethod: GtOpenAIResponse
leJsonV4Name

	^ #gtOpenAIResponse
%

category: 'as yet unclassified'
classmethod: GtOpenAIResponse
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#status -> #status.
		#error -> #error.
		#incomplete_details -> #incompleteDetails.
		#instructions -> #instructions.
		#max_output_tokens -> #maxOutputTokens.
		#model -> #model.
		#output -> #output.
		#parallel_tool_calls -> #parallelToolCalls.
		#previous_response_id -> #previousResponseId.
		#reasoning -> #reasoning.
		#store -> #store.
		#temperature -> #temperature.
		#text -> #text.
		#tool_choice -> #toolChoice.
		#tools -> #tools.
		#top_p -> #topP.
		#truncation -> #truncation.
		#usage -> #usage.
		#user -> #user.
		#metadata -> #metadata}
%

!		Instance methods for 'GtOpenAIResponse'

category: 'accessing'
method: GtOpenAIResponse
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIResponse
createdAt: anObject
	createdAt := anObject
%

category: 'accessing'
method: GtOpenAIResponse
error
	^ error
%

category: 'accessing'
method: GtOpenAIResponse
error: anObject
	error := anObject
%

category: 'as yet unclassified'
method: GtOpenAIResponse
hasToolCalls
	^ self toolCalls isNotEmpty
%

category: 'accessing'
method: GtOpenAIResponse
id
	^ id
%

category: 'accessing'
method: GtOpenAIResponse
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIResponse
incompleteDetails
	^ incompleteDetails
%

category: 'accessing'
method: GtOpenAIResponse
incompleteDetails: anObject
	incompleteDetails := anObject
%

category: 'accessing'
method: GtOpenAIResponse
instructions
	^ instructions
%

category: 'accessing'
method: GtOpenAIResponse
instructions: anObject
	instructions := anObject
%

category: 'accessing'
method: GtOpenAIResponse
maxOutputTokens
	^ maxOutputTokens
%

category: 'accessing'
method: GtOpenAIResponse
maxOutputTokens: anObject
	maxOutputTokens := anObject
%

category: 'accessing'
method: GtOpenAIResponse
metadata
	^ metadata
%

category: 'accessing'
method: GtOpenAIResponse
metadata: anObject
	metadata := anObject
%

category: 'accessing'
method: GtOpenAIResponse
model
	^ model
%

category: 'accessing'
method: GtOpenAIResponse
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIResponse
output
	^ output
%

category: 'accessing'
method: GtOpenAIResponse
output: anObject
	output := anObject collect: [ :aMessage | GtOpenAIMessage from: aMessage ]
%

category: 'accessing'
method: GtOpenAIResponse
parallelToolCalls
	^ parallelToolCalls
%

category: 'accessing'
method: GtOpenAIResponse
parallelToolCalls: anObject
	parallelToolCalls := anObject
%

category: 'accessing'
method: GtOpenAIResponse
previousResponseId
	^ previousResponseId
%

category: 'accessing'
method: GtOpenAIResponse
previousResponseId: anObject
	previousResponseId := anObject
%

category: 'accessing'
method: GtOpenAIResponse
reasoning
	^ reasoning
%

category: 'accessing'
method: GtOpenAIResponse
reasoning: anObject
	reasoning := anObject
%

category: 'accessing'
method: GtOpenAIResponse
status
	^ status
%

category: 'accessing'
method: GtOpenAIResponse
status: anObject
	status := anObject
%

category: 'accessing'
method: GtOpenAIResponse
store
	^ store
%

category: 'accessing'
method: GtOpenAIResponse
store: anObject
	store := anObject
%

category: 'accessing'
method: GtOpenAIResponse
temperature
	^ temperature
%

category: 'accessing'
method: GtOpenAIResponse
temperature: anObject
	temperature := anObject
%

category: 'accessing'
method: GtOpenAIResponse
text
	^ text
%

category: 'accessing'
method: GtOpenAIResponse
text: anObject
	text := anObject
%

category: 'as yet unclassified'
method: GtOpenAIResponse
toolCalls
	^ self output
		select: [ :aMessage | (aMessage rawData at: 'type') = 'function_call' ]
		thenCollect: [ :aMessage | 
			GtLlmFunctionToolCall new
				rawData: aMessage rawData;
				id: (aMessage rawData at: 'call_id');
				name: (aMessage rawData at: 'name');
				arguments: (STONJSON fromString: (aMessage rawData at: 'arguments')) ]
%

category: 'accessing'
method: GtOpenAIResponse
toolChoice
	^ toolChoice
%

category: 'accessing'
method: GtOpenAIResponse
toolChoice: anObject
	toolChoice := anObject
%

category: 'accessing'
method: GtOpenAIResponse
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIResponse
tools: anObject
	tools := anObject
%

category: 'accessing'
method: GtOpenAIResponse
topP
	^ topP
%

category: 'accessing'
method: GtOpenAIResponse
topP: anObject
	topP := anObject
%

category: 'accessing'
method: GtOpenAIResponse
truncation
	^ truncation
%

category: 'accessing'
method: GtOpenAIResponse
truncation: anObject
	truncation := anObject
%

category: 'accessing'
method: GtOpenAIResponse
usage
	^ usage
%

category: 'accessing'
method: GtOpenAIResponse
usage: anObject
	usage := anObject
%

category: 'accessing'
method: GtOpenAIResponse
user
	^ user
%

category: 'accessing'
method: GtOpenAIResponse
user: anObject
	user := anObject
%

! Class implementation for 'GtOpenAIThread'

!		Class methods for 'GtOpenAIThread'

category: 'accessing'
classmethod: GtOpenAIThread
leJsonV4Name

	^ #gtOpenAIThread
%

category: 'accessing'
classmethod: GtOpenAIThread
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#metadata -> #metadata.
		#tools -> #tools.
		#tool_resources -> #toolResources}
%

!		Instance methods for 'GtOpenAIThread'

category: 'accessing'
method: GtOpenAIThread
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIThread
createdAt: anObject
	createdAt := anObject
%

category: 'accessing'
method: GtOpenAIThread
id
	^ id
%

category: 'accessing'
method: GtOpenAIThread
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIThread
messages
	^ messages ifNil: [ self updateMessages ]
%

category: 'accessing'
method: GtOpenAIThread
metadata
	^ metadata
%

category: 'accessing'
method: GtOpenAIThread
metadata: anObject
	metadata := anObject
%

category: 'accessing'
method: GtOpenAIThread
sendMessage: aString
	| aMessage |
	aMessage := GtLlmUserMessage new content: aString.

	self client addMessage: aMessage toThread: self id
%

category: 'accessing'
method: GtOpenAIThread
toolResources
	^ toolResources
%

category: 'accessing'
method: GtOpenAIThread
toolResources: anObject
	toolResources := anObject
%

category: 'accessing'
method: GtOpenAIThread
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIThread
tools: anObject
	tools := anObject
%

category: 'accessing'
method: GtOpenAIThread
updateMessages
	^ messages := self client listMessagesForThread: self id
%

! Class implementation for 'GtOpenAIThreadRun'

!		Class methods for 'GtOpenAIThreadRun'

category: 'accessing'
classmethod: GtOpenAIThreadRun
leJsonV4Name

	^ #gtOpenAIThreadRun
%

category: 'accessing'
classmethod: GtOpenAIThreadRun
serializationProperties
	^ {#id -> #id.
		#created_at -> #createdAt.
		#assistant_id -> #assistantId.
		#thread_id -> #threadId.
		#status -> #status.
		#started_at -> #startedAt.
		#expires_at -> #expiresAt.
		#cancelled_at -> #cancelledAt.
		#failed_at -> #failedAt.
		#completed_at -> #completedAt.
		#last_error -> #lastError.
		#model -> #model.
		#instructions -> #instructions.
		#tools -> #tools.
		#file_ids -> #fileIds.
		#metadata -> #metadata.
		#usage -> #usage}
%

!		Instance methods for 'GtOpenAIThreadRun'

category: 'accessing'
method: GtOpenAIThreadRun
assistantId
	^ assistantId
%

category: 'accessing'
method: GtOpenAIThreadRun
assistantId: anObject
	assistantId := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
cancelledAt
	^ cancelledAt
%

category: 'accessing'
method: GtOpenAIThreadRun
cancelledAt: anObject
	cancelledAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
completedAt
	^ completedAt
%

category: 'accessing'
method: GtOpenAIThreadRun
completedAt: anObject
	completedAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIThreadRun
createdAt: anObject
	createdAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
doneAt
	^ self cancelledAt ifNil: [ self completedAt ifNil: [ self failedAt ] ]
%

category: 'accessing'
method: GtOpenAIThreadRun
expiresAt
	^ expiresAt
%

category: 'accessing'
method: GtOpenAIThreadRun
expiresAt: anObject
	expiresAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
failedAt
	^ failedAt
%

category: 'accessing'
method: GtOpenAIThreadRun
failedAt: anObject
	failedAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
failureMessage
	^ self lastError at: 'message'
%

category: 'accessing'
method: GtOpenAIThreadRun
fileIds
	^ fileIds
%

category: 'accessing'
method: GtOpenAIThreadRun
fileIds: anObject
	fileIds := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
files
	^ files
		ifNil: [ files := GtOpenAIFilesGroup
					withAll: (self fileIds collect: [ :aFileId | self client getFile: aFileId ]) ]
%

category: 'accessing'
method: GtOpenAIThreadRun
gtErrorFor: aView
	<gtView>
	self isFailed ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Failure';
		priority: 1;
		text: [ self failureMessage ]
%

category: 'accessing'
method: GtOpenAIThreadRun
gtFilesFor: aView
	<gtView>
	^ aView forward
		title: 'Files';
		priority: 5;
		object: [ self files ];
		view: #gtFilesFor:
%

category: 'accessing'
method: GtOpenAIThreadRun
gtToolsFor: aView
	<gtView>
	^ aView list
		title: 'Tools';
		priority: 2;
		items: [ self tools ];
		itemText: #type
%

category: 'accessing'
method: GtOpenAIThreadRun
id
	^ id
%

category: 'accessing'
method: GtOpenAIThreadRun
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
initialize
	super initialize.
	
	fileIds := OrderedCollection new
%

category: 'accessing'
method: GtOpenAIThreadRun
instructions
	^ instructions
%

category: 'accessing'
method: GtOpenAIThreadRun
instructions: anObject
	instructions := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
isCancelled
	^ self status = 'cancelled'
%

category: 'accessing'
method: GtOpenAIThreadRun
isCancelling
	^ self status = 'cancelling'
%

category: 'accessing'
method: GtOpenAIThreadRun
isCompleted
	^ self status = 'completed'
%

category: 'accessing'
method: GtOpenAIThreadRun
isDone
	^ self isCancelled
		or: [ self isExpired or: [ self isFailed or: [ self isCompleted ] ] ]
%

category: 'accessing'
method: GtOpenAIThreadRun
isExpired
	^ self status = 'expired'
%

category: 'accessing'
method: GtOpenAIThreadRun
isFailed
	^ self status = 'failed'
%

category: 'accessing'
method: GtOpenAIThreadRun
isInProgress
	^ self status = 'in_progress'
%

category: 'accessing'
method: GtOpenAIThreadRun
isQueued
	^ self status = 'queued'
%

category: 'accessing'
method: GtOpenAIThreadRun
isRequiringAction
	^ self status = 'requires_action'
%

category: 'accessing'
method: GtOpenAIThreadRun
lastError
	^ lastError
%

category: 'accessing'
method: GtOpenAIThreadRun
lastError: anObject
	lastError := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
metadata
	^ metadata
%

category: 'accessing'
method: GtOpenAIThreadRun
metadata: anObject
	metadata := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
model
	^ model
%

category: 'accessing'
method: GtOpenAIThreadRun
model: anObject
	model := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
startedAt
	^ startedAt
%

category: 'accessing'
method: GtOpenAIThreadRun
startedAt: anObject
	startedAt := self deserializeTime: anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
status
	^ status
%

category: 'accessing'
method: GtOpenAIThreadRun
status: anObject
	status := anObject
%

category: 'accessing'
method: GtOpenAIThreadRun
threadId
	^ threadId
%

category: 'accessing'
method: GtOpenAIThreadRun
threadId: anObject
	threadId := anObject
%

category: 'as yet unclassified'
method: GtOpenAIThreadRun
toolCalls
	^ ((self rawData at: 'required_action' at: 'submit_tool_outputs')
		at: 'tool_calls') collect: [ :aDict | GtLlmFunctionToolCall from: aDict ]
%

category: 'accessing'
method: GtOpenAIThreadRun
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIThreadRun
tools: anObject
	tools := anObject collect: [ :aValue | GtLlmTool from: aValue ]
%

category: 'accessing'
method: GtOpenAIThreadRun
usage
	^ usage
%

category: 'accessing'
method: GtOpenAIThreadRun
usage: anObject
	usage := anObject ifNotNil: [ GtOpenAIUsage from: anObject ]
%

! Class implementation for 'GtOpenAIUsage'

!		Class methods for 'GtOpenAIUsage'

category: 'accessing'
classmethod: GtOpenAIUsage
leJsonV4Name

	^ #gtOpenAIUsage
%

category: 'accessing'
classmethod: GtOpenAIUsage
serializationProperties
	^ {#completion_tokens -> #completionTokens.
		#prompt_tokens -> #promptTokens.
		#total_tokens -> #totalTokens}
%

!		Instance methods for 'GtOpenAIUsage'

category: 'accessing'
method: GtOpenAIUsage
completionTokens
	^ completionTokens
%

category: 'accessing'
method: GtOpenAIUsage
completionTokens: anObject
	completionTokens := anObject
%

category: 'accessing'
method: GtOpenAIUsage
promptTokens
	^ promptTokens
%

category: 'accessing'
method: GtOpenAIUsage
promptTokens: anObject
	promptTokens := anObject
%

category: 'accessing'
method: GtOpenAIUsage
totalTokens
	^ totalTokens
%

category: 'accessing'
method: GtOpenAIUsage
totalTokens: anObject
	totalTokens := anObject
%

! Class implementation for 'GtOpenAIVectorStore'

!		Class methods for 'GtOpenAIVectorStore'

category: 'accessing'
classmethod: GtOpenAIVectorStore
leJsonV4Name

	^ #gtOpenAIVectorStore
%

category: 'as yet unclassified'
classmethod: GtOpenAIVectorStore
serializationProperties
	^ {#id -> #id.
		#name -> #name.
		#created_at -> #createdAt.
		#status -> #status.
		#usage_bytes -> #usageBytes.
		#file_counts -> #fileCounts}
%

!		Instance methods for 'GtOpenAIVectorStore'

category: 'accessing'
method: GtOpenAIVectorStore
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIVectorStore
createdAt: anObject
	createdAt := anObject
%

category: 'accessing'
method: GtOpenAIVectorStore
fileCounts
	^ fileCounts
%

category: 'accessing'
method: GtOpenAIVectorStore
fileCounts: anObject
	fileCounts := anObject
%

category: 'accessing'
method: GtOpenAIVectorStore
id
	^ id
%

category: 'accessing'
method: GtOpenAIVectorStore
id: anObject
	id := anObject
%

category: 'accessing'
method: GtOpenAIVectorStore
name
	^ name
%

category: 'accessing'
method: GtOpenAIVectorStore
name: anObject
	name := anObject
%

category: 'accessing'
method: GtOpenAIVectorStore
status
	^ status
%

category: 'accessing'
method: GtOpenAIVectorStore
status: anObject
	status := anObject
%

category: 'accessing'
method: GtOpenAIVectorStore
usageBytes
	^ usageBytes
%

category: 'accessing'
method: GtOpenAIVectorStore
usageBytes: anObject
	usageBytes := anObject
%

! Class implementation for 'GtLlmErrorThreadMessage'

!		Instance methods for 'GtLlmErrorThreadMessage'

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
action
	^ nil
%

category: 'accessing'
method: GtLlmErrorThreadMessage
ancestor
	^ self chat messages first
%

category: 'accessing'
method: GtLlmErrorThreadMessage
annotations
	^ #()
%

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
arguments
	^ {}
%

category: 'accessing'
method: GtLlmErrorThreadMessage
chat
	^ chat
%

category: 'accessing'
method: GtLlmErrorThreadMessage
chat: anObject
	chat := anObject
%

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
content
	^ self contentText
%

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
contentJson
	^ {} asDictionary
%

category: 'accessing'
method: GtLlmErrorThreadMessage
contentSummary
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
%

category: 'accessing'
method: GtLlmErrorThreadMessage
contentText
	^ self exception messageText
%

category: 'accessing'
method: GtLlmErrorThreadMessage
createdAt
	^ createdAt
%

category: 'accessing'
method: GtLlmErrorThreadMessage
createdAt: anObject
	createdAt := anObject
%

category: 'accessing'
method: GtLlmErrorThreadMessage
exception
	^ exception
%

category: 'accessing'
method: GtLlmErrorThreadMessage
exception: anObject
	exception := anObject
%

category: 'testing'
method: GtLlmErrorThreadMessage
hasResponse
	^ true
%

category: 'accessing'
method: GtLlmErrorThreadMessage
id
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
%

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
initialize
	super initialize.
	
	self createdAt: DateAndTime now.
%

category: 'testing'
method: GtLlmErrorThreadMessage
isAssistantRole
	^ true
%

category: 'accessing'
method: GtLlmErrorThreadMessage
isFailure
	^ true
%

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
isRawMessage
	^ false
%

category: 'as yet unclassified'
method: GtLlmErrorThreadMessage
role
	^ 'Error'
%

category: 'accessing'
method: GtLlmErrorThreadMessage
senderText
	^  'System'
%

category: 'accessing'
method: GtLlmErrorThreadMessage
styler
	^ nil
%

category: 'subscriptions'
method: GtLlmErrorThreadMessage
unsubscribe: anObject
	"do nothing"

	
%

category: 'subscriptions'
method: GtLlmErrorThreadMessage
when: anEventSelector send: aMessageSelector to: anObject
	"do nothing"

	
%

! Class implementation for 'GtLlmFailureThreadMessage'

!		Instance methods for 'GtLlmFailureThreadMessage'

category: 'as yet unclassified'
method: GtLlmFailureThreadMessage
action
	^ ''
%

category: 'accessing'
method: GtLlmFailureThreadMessage
ancestor
	^ self chat messages first
%

category: 'accessing'
method: GtLlmFailureThreadMessage
annotations
	^ #()
%

category: 'as yet unclassified'
method: GtLlmFailureThreadMessage
arguments
	^ {}
%

category: 'accessing'
method: GtLlmFailureThreadMessage
chat
	^ chat
%

category: 'accessing'
method: GtLlmFailureThreadMessage
chat: anObject
	chat := anObject
%

category: 'as yet unclassified'
method: GtLlmFailureThreadMessage
contentJson
	^ {} asDictionary
%

category: 'accessing'
method: GtLlmFailureThreadMessage
contentSummary
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
%

category: 'accessing'
method: GtLlmFailureThreadMessage
contentText
	^ self failureText ifNil: [ '' ]
%

category: 'accessing'
method: GtLlmFailureThreadMessage
createdAt
	^ createdAt
%

category: 'accessing'
method: GtLlmFailureThreadMessage
createdAt: anObject
	createdAt := anObject
%

category: 'accessing'
method: GtLlmFailureThreadMessage
failureText
	^ failureText
%

category: 'accessing'
method: GtLlmFailureThreadMessage
failureText: anObject
	failureText := anObject
%

category: 'testing'
method: GtLlmFailureThreadMessage
hasResponse
	^ true
%

category: 'accessing'
method: GtLlmFailureThreadMessage
id
	^ '3a876ca3-32ce-0d00-b7b2-b9390ae84159'
%

category: 'testing'
method: GtLlmFailureThreadMessage
isAssistantRole
	^ true
%

category: 'accessing'
method: GtLlmFailureThreadMessage
isFailure
	^ true
%

category: 'accessing'
method: GtLlmFailureThreadMessage
senderText
	^  'Assistant'
%

category: 'accessing'
method: GtLlmFailureThreadMessage
styler
	^ nil
%

category: 'subscriptions'
method: GtLlmFailureThreadMessage
unsubscribe: anObject
	"do nothing"

	
%

category: 'subscriptions'
method: GtLlmFailureThreadMessage
when: anEventSelector send: aMessageSelector to: anObject
	"do nothing"

	
%

! Class implementation for 'GtLlmFeatures'

!		Class methods for 'GtLlmFeatures'

category: 'as yet unclassified'
classmethod: GtLlmFeatures
beExperimental
	self enableInCoder useMultiStep
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
disableInCoder
	UseCoder := false
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
enableInCoder
	UseCoder := true
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
initialize
	UseCoder := false.
	MultiStep := false
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
isEnabledInCoder
	^ UseCoder ifNil: [ UseCoder := false ]
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
multiStep
	^ MultiStep ifNil: [ false ]
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
setEnableInCoder: aBool
	UseCoder := aBool
%

category: 'as yet unclassified'
classmethod: GtLlmFeatures
useMultiStep
	MultiStep := true
%

! Class implementation for 'GtLlmFineTuningFile'

!		Instance methods for 'GtLlmFineTuningFile'

category: 'accessing'
method: GtLlmFineTuningFile
addConversation: aConversation
	conversations add: aConversation
%

category: 'accessing'
method: GtLlmFineTuningFile
asJson
	^ Character linefeed
		join: (self serialize collect: [ :aDict | STONJSON toString: aDict ])
%

category: 'accessing'
method: GtLlmFineTuningFile
basename
	^ self name
%

category: 'accessing'
method: GtLlmFineTuningFile
binaryContents
	^ self asJson asByteString
%

category: 'accessing'
method: GtLlmFineTuningFile
contents
	^ self asJson
%

category: 'accessing'
method: GtLlmFineTuningFile
conversations
	^ conversations
%

category: 'accessing'
method: GtLlmFineTuningFile
conversations: anObject
	conversations := anObject
%

category: 'accessing'
method: GtLlmFineTuningFile
defaultModel
	^ 'gpt-3.5-turbo'
%

category: 'accessing'
method: GtLlmFineTuningFile
gtConversationsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Conversations';
		priority: 1;
		items: [ conversations ];
		column: 'Size'
			text: #size
			width: 50;
		column: 'Messages'
			text: [ :aConversation | 
				Character enter
					join: (aConversation items
							collect: [ :aMessage | aMessage role , ': ' , aMessage content ]) ]
%

category: 'accessing'
method: GtLlmFineTuningFile
gtJsonlFor: aView
	<gtView>
	^ aView forward
		title: 'JSONL';
		priority: 2;
		object: [ self asJson ];
		view: #gtLiveFor:
%

category: 'accessing'
method: GtLlmFineTuningFile
initialize
	super initialize.
	
	conversations := OrderedCollection new.
	model := self defaultModel
%

category: 'accessing'
method: GtLlmFineTuningFile
model
	^ model
%

category: 'accessing'
method: GtLlmFineTuningFile
model: anObject
	model := anObject
%

category: 'accessing'
method: GtLlmFineTuningFile
name
	^ name
%

category: 'accessing'
method: GtLlmFineTuningFile
name: anObject
	name := anObject
%

category: 'accessing'
method: GtLlmFineTuningFile
pricePerToken
	^ ({'gpt-3.5-turbo' -> 8.
		'gpt-4o-mini' -> 3.
		'davinci-002' -> 6.
		'babbage-002' -> 0.4} asDictionary
		at: ((self model beginsWith: 'gpt-4o-mini')
				ifTrue: [ 'gpt-4o-mini' ]
				ifFalse: [ self model ])) / 1000000
%

category: 'accessing'
method: GtLlmFineTuningFile
serialize
	^ conversations collect: #serialize
%

! Class implementation for 'GtLlmGroup'

!		Class methods for 'GtLlmGroup'

category: 'accessing'
classmethod: GtLlmGroup
leJsonV4Name

	^ #gtLlmGroup
%

category: 'as yet unclassified'
classmethod: GtLlmGroup
withAll: aCollection
	^ self new 
		initializeWith: aCollection
%

!		Instance methods for 'GtLlmGroup'

category: 'visiting'
method: GtLlmGroup
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmGroup: self
%

category: 'accessing'
method: GtLlmGroup
add: anItem
	self items add: anItem
%

category: 'accessing'
method: GtLlmGroup
addAll: aCollection
	self items addAll: aCollection
%

category: 'accessing'
method: GtLlmGroup
addFirst: anItem
	self items addFirst: anItem
%

category: 'accessing'
method: GtLlmGroup
addItem: anItem
	self items add: anItem
%

category: 'accessing'
method: GtLlmGroup
addItems: aCollection
	self items addAll: aCollection
%

category: 'accessing'
method: GtLlmGroup
allButFirst
	^ self species withAll: self items allButFirst
%

category: 'accessing'
method: GtLlmGroup
allButLast
	^ self species withAll: self items allButLast
%

category: 'accessing'
method: GtLlmGroup
anyOne
	^ self items anyOne
%

category: 'accessing'
method: GtLlmGroup
anySatisfy: aBlock
	^ self items anySatisfy: aBlock
%

category: 'accessing'
method: GtLlmGroup
asArray
	^ self items asArray
%

category: 'accessing'
method: GtLlmGroup
asBag
	^ self items asBag
%

category: 'accessing'
method: GtLlmGroup
asOrderedCollection
	^ self items asOrderedCollection
%

category: 'accessing'
method: GtLlmGroup
asSet
	^ self items asSet
%

category: 'accessing'
method: GtLlmGroup
asSortedCollection: aBlock
	^ self items asSortedCollection: aBlock
%

category: 'accessing'
method: GtLlmGroup
at: anIndex
	^ self items at: anIndex
%

category: 'enumerating'
method: GtLlmGroup
collect: aBlock
	^ self items collect: aBlock
%

category: 'enumerating'
method: GtLlmGroup
collect: aBlock as: aClass
	^ self items 
		collect: aBlock as: aClass
%

category: 'enumerating'
method: GtLlmGroup
collect: collectBlock thenReject: selectBlock
	^ self items collect: collectBlock thenReject: selectBlock
%

category: 'enumerating'
method: GtLlmGroup
collect: collectBlock thenSelect: selectBlock
	^ self items collect: collectBlock thenSelect: selectBlock
%

category: 'enumerating'
method: GtLlmGroup
collectWithIndex: aBlock
	^ self items collectWithIndex: aBlock
%

category: 'enumerating'
method: GtLlmGroup
detect: aBlock 
	^ self items detect: aBlock 
%

category: 'enumerating'
method: GtLlmGroup
detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
	^ self items 
		detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
%

category: 'enumerating'
method: GtLlmGroup
detect: aBlock ifNone: exceptionBlock
	^ self items 
		detect: aBlock ifNone: exceptionBlock
%

category: 'accessing'
method: GtLlmGroup
detectIndex: aBlock
	^ self items detectIndex: aBlock
%

category: 'accessing'
method: GtLlmGroup
detectIndex: aBlock ifNone: exceptionBlock
	^ self items detectIndex: aBlock ifNone: exceptionBlock
%

category: 'enumerating'
method: GtLlmGroup
detectMax: aBlock 
	^ self items detectMax: aBlock 
%

category: 'enumerating'
method: GtLlmGroup
detectMin: aBlock 
	^ self items detectMin: aBlock 
%

category: 'accessing'
method: GtLlmGroup
do: aBlock
	^ self items do: aBlock
%

category: 'compatibility - DeepTraverser'
method: GtLlmGroup
dtRawTraverseUsing: aStream
	self do: [ :each | aStream traverse: each ]
%

category: 'compatibility - DeepTraverser'
method: GtLlmGroup
dtTraverseStartUsing: aStream
	self do: [ :each | each dtTraverseStartUsing: aStream ]
%

category: 'compatibility - DeepTraverser'
method: GtLlmGroup
dtTraverseUsing: aStream
	self do: [ :each | each dtTraverseUsing: aStream ]
%

category: 'accessing'
method: GtLlmGroup
first
	^ self items first
%

category: 'accessing'
method: GtLlmGroup
first: aCount
	^ self species 
		withAll: (self items first: aCount)
%

category: 'accessing'
method: GtLlmGroup
flatCollect: aBlock
	^ self items flatCollect: aBlock
%

category: 'accessing'
method: GtLlmGroup
flatCollect: aBlock as: aClass
	^ self items flatCollect: aBlock as: aClass
%

category: 'accessing'
method: GtLlmGroup
groupedBy: aBlock 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	| result |
	result := Dictionary new.
	self do:[:each | 
		| key collection |
		key := aBlock value: each.
		collection := result at: key ifAbsentPut: [ OrderedCollection new].
		collection add: each].
		
	result keysAndValuesDo: [:key :value | 
		result at: key put: (self species withAll: value)].

	^result
%

category: 'accessing'
method: GtLlmGroup
groupedBy: aBlock having: conditionBlock 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	^ (self groupedBy: aBlock) select: conditionBlock
%

category: 'testing'
method: GtLlmGroup
identityIncludes: anObject
	^ self items identityIncludes: anObject
%

category: 'testing'
method: GtLlmGroup
ifEmpty: aBlock
	^ self items ifEmpty: aBlock
%

category: 'testing'
method: GtLlmGroup
ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
	^ self items ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
%

category: 'testing'
method: GtLlmGroup
ifNotEmpty: aBlock
	^ self items ifNotEmpty: aBlock
%

category: 'testing'
method: GtLlmGroup
ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
	^ self items ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
%

category: 'testing'
method: GtLlmGroup
includes: anObject
	^ self items includes: anObject
%

category: 'accessing'
method: GtLlmGroup
indexOf: aBlock
	^ self items indexOf: aBlock
%

category: 'initialization'
method: GtLlmGroup
initializeWith: aCollection
	items := aCollection
%

category: 'accessing'
method: GtLlmGroup
inject: anObject into: aBlock
	^ self items inject: anObject into: aBlock
%

category: 'accessing'
method: GtLlmGroup
isCollection
	^ true
%

category: 'testing'
method: GtLlmGroup
isEmpty

	^ self items isEmpty
%

category: 'testing'
method: GtLlmGroup
isEmptyOrNil
	^ self items isEmptyOrNil
%

category: 'testing'
method: GtLlmGroup
isNotEmpty

	^ self items isNotEmpty
%

category: 'accessing'
method: GtLlmGroup
items
	^ items ifNil: [
		items := OrderedCollection new ]
%

category: 'private - serialization'
method: GtLlmGroup
items: aCollection

	items := aCollection
%

category: 'accessing'
method: GtLlmGroup
last
	^ self items last
%

category: 'accessing'
method: GtLlmGroup
last: aCount
	^ self species 
		withAll: (self items last: aCount)
%

category: 'accessing'
method: GtLlmGroup
overlappingPairsDo: aBlock
	^ self items overlappingPairsDo: aBlock
%

category: 'printing'
method: GtLlmGroup
printOn: aStream
	super printOn: aStream.
	
	aStream 
		<< ' [';
		print: self size;
		<< ' ';
		<< (self size = 1 
			ifTrue: [ 'item' ]
			ifFalse: [ 'items' ]);
		<< ']'
%

category: 'enumerating'
method: GtLlmGroup
reject: aBlock
	^ self species 
		withAll: (self items reject: aBlock)
%

category: 'accessing'
method: GtLlmGroup
remove: anItem
	self items remove: anItem
%

category: 'accessing'
method: GtLlmGroup
removeAll
	self items removeAll
%

category: 'accessing'
method: GtLlmGroup
removeLast
	self items removeLast
%

category: 'enumerating'
method: GtLlmGroup
reversed
	^ self species 
		withAll: (self items reversed)
%

category: 'enumerating'
method: GtLlmGroup
select: aBlock
	^ self species 
		withAll: (self items select: aBlock)
%

category: 'accessing'
method: GtLlmGroup
size
	^ self items size
%

category: 'sorting'
method: GtLlmGroup
sorted: aPredicate
	^ self species withAll: (self items sorted: aPredicate)
%

category: 'accessing'
method: GtLlmGroup
withIndexCollect: aBlock
	^ self items withIndexCollect: aBlock
%

category: 'accessing'
method: GtLlmGroup
withIndexDo: aBlock
	^ self items withIndexDo: aBlock
%

! Class implementation for 'GtLlmActionsGroup'

!		Class methods for 'GtLlmActionsGroup'

category: 'accessing'
classmethod: GtLlmActionsGroup
leJsonV4Name

	^ #gtLlmActionsGroup
%

! Class implementation for 'GtLlmAssistantActionExamplesGroup'

!		Class methods for 'GtLlmAssistantActionExamplesGroup'

category: 'accessing'
classmethod: GtLlmAssistantActionExamplesGroup
fromThreadMessages: aMessageGroup
	^ self
		withAll: ((aMessageGroup items groupsOf: 2)
				collect: [ :aPair | 
					| split |
					split := aPair first contentText lines.
					GtLlmAssistantActionExample new
						instruction: split first;
						input: (Character linefeed join: (split allButFirst: 3));
						output: aPair second contentText ])
%

category: 'accessing'
classmethod: GtLlmAssistantActionExamplesGroup
leJsonV4Name

	^ #gtLlmAssistantActionExamplesGroup
%

!		Instance methods for 'GtLlmAssistantActionExamplesGroup'

category: 'accessing'
method: GtLlmAssistantActionExamplesGroup
gtExamplesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Examples';
		priority: 1;
		items: [ self items ];
		column: 'Instruction'
			text: #instruction
			weight: 0.5;
		column: 'Input' text: #input;
		column: 'Output' text: #output
%

! Class implementation for 'GtLlmInspectorMethodSummaryGroup'

!		Class methods for 'GtLlmInspectorMethodSummaryGroup'

category: 'accessing'
classmethod: GtLlmInspectorMethodSummaryGroup
leJsonV4Name

	^ #gtLlmInspectorMethodSummaryGroup
%

!		Instance methods for 'GtLlmInspectorMethodSummaryGroup'

category: 'accessing'
method: GtLlmInspectorMethodSummaryGroup
gtPhlowMethodsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Methods';
		priority: 1;
		items: [ self items ];
		column: 'Selector' text: #name
%

! Class implementation for 'GtLlmInspectorSlotSummaryGroup'

!		Class methods for 'GtLlmInspectorSlotSummaryGroup'

category: 'accessing'
classmethod: GtLlmInspectorSlotSummaryGroup
leJsonV4Name

	^ #gtLlmInspectorSlotSummaryGroup
%

!		Instance methods for 'GtLlmInspectorSlotSummaryGroup'

category: 'accessing'
method: GtLlmInspectorSlotSummaryGroup
gtSlotsFor: aView
	<gtView>
	^ aView columnedList title: 'Slots'; priority: 1; items: [self items]; column: 'Name' text: #name; column: 'Value' text: #slotValue
%

! Class implementation for 'GtLlmInspectorViewSummaryGroup'

!		Class methods for 'GtLlmInspectorViewSummaryGroup'

category: 'accessing'
classmethod: GtLlmInspectorViewSummaryGroup
leJsonV4Name

	^ #gtLlmInspectorViewSummaryGroup
%

!		Instance methods for 'GtLlmInspectorViewSummaryGroup'

category: 'accessing'
method: GtLlmInspectorViewSummaryGroup
gtPhlowViewsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Views';
		priority: 1;
		items: [ self items ];
		column: 'Selector' text: #selector;
		column: 'Code' text: #code weight: 4
%

! Class implementation for 'GtLlmMessagePartGroup'

!		Class methods for 'GtLlmMessagePartGroup'

category: 'accessing'
classmethod: GtLlmMessagePartGroup
leJsonV4Name

	^ #gtLlmMessagePartGroup
%

!		Instance methods for 'GtLlmMessagePartGroup'

category: 'as yet unclassified'
method: GtLlmMessagePartGroup
serialize
	^ self items collect: #serialize
%

category: 'as yet unclassified'
method: GtLlmMessagePartGroup
serializeInline
	^ self items collect: #serializeInline
%

! Class implementation for 'GtLlmMessagesGroup'

!		Class methods for 'GtLlmMessagesGroup'

category: 'accessing'
classmethod: GtLlmMessagesGroup
leJsonV4Name

	^ #gtLlmMessagesGroup
%

!		Instance methods for 'GtLlmMessagesGroup'

category: 'visiting'
method: GtLlmMessagesGroup
acceptVisitor: aVisitor

	^ aVisitor visitGtLlmMessagesGroup: self
%

category: 'converting'
method: GtLlmMessagesGroup
asGPhlowItemsIterator
	^ GtRemotePhlowGenericCollectionIterator forCollection: self
%

category: 'accessing'
method: GtLlmMessagesGroup
asJson
	^ STONJSON toString: self serialize
%

category: 'accessing'
method: GtLlmMessagesGroup
gtMessagesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role'
			text: [ :item | item role ]
			width: 100;
		column: 'Message' text: [ :item | item content ]
%

category: 'accessing'
method: GtLlmMessagesGroup
serialize
	^ {'messages' -> (self items collect: #serialize)} asDictionary
%

! Class implementation for 'GtLlmNearestEmbeddingsGroup'

!		Class methods for 'GtLlmNearestEmbeddingsGroup'

category: 'accessing'
classmethod: GtLlmNearestEmbeddingsGroup
leJsonV4Name

	^ #gtLlmNearestEmbeddingsGroup
%

!		Instance methods for 'GtLlmNearestEmbeddingsGroup'

category: 'accessing'
method: GtLlmNearestEmbeddingsGroup
gtEmbeddingsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Embeddings';
		priority: 1;
		items: [ self items ];
		column: 'Distance' text: #distance width: 150;
		column: 'Input' text: #input
%

! Class implementation for 'GtLlmToolsGroup'

!		Class methods for 'GtLlmToolsGroup'

category: 'accessing'
classmethod: GtLlmToolsGroup
leJsonV4Name

	^ #gtLlmToolsGroup
%

!		Instance methods for 'GtLlmToolsGroup'

category: 'views'
method: GtLlmToolsGroup
gtItemsFor: aView
	<gtView>
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Tools';
		items: [ items ];
		column: 'Name' text: [ :each | each name ];
		column: 'Parameters' text: [ :each | ', ' join: each parameters ];
		column: 'Description' text: [ :each | each description ]
%

category: 'as yet unclassified'
method: GtLlmToolsGroup
performToolCall: aToolCall
	| tool |
	tool := self detect: [ :aTool | aTool name = aToolCall name ].

	^ tool performToolCall: aToolCall
%

category: 'accessing'
method: GtLlmToolsGroup
serialize
	^ Character cr join: (self items collect: [ :aTool | '- ' , aTool serialize ])
%

! Class implementation for 'GtMcpPromptsGroup'

!		Class methods for 'GtMcpPromptsGroup'

category: 'accessing'
classmethod: GtMcpPromptsGroup
leJsonV4Name

	^ #gtMcpPromptsGroup
%

!		Instance methods for 'GtMcpPromptsGroup'

category: 'as yet unclassified'
method: GtMcpPromptsGroup
gtPromptsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Prompts';
		priority: 1;
		items: [ self items ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description;
		column: 'Arguments' text: [ :aPrompt | ',' join: aPrompt arguments ]
%

! Class implementation for 'GtMcpResourcesGroup'

!		Class methods for 'GtMcpResourcesGroup'

category: 'accessing'
classmethod: GtMcpResourcesGroup
leJsonV4Name

	^ #gtMcpResourcesGroup
%

!		Instance methods for 'GtMcpResourcesGroup'

category: 'as yet unclassified'
method: GtMcpResourcesGroup
gtResourcesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Resources';
		priority: 1;
		items: [ self items ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description;
		column: 'URI' text: #uri
%

! Class implementation for 'GtOllamaEmbeddingsGroup'

!		Class methods for 'GtOllamaEmbeddingsGroup'

category: 'accessing'
classmethod: GtOllamaEmbeddingsGroup
from: aList
	^ self
		withAll: ((aList at: 'embeddings')
				collect: [ :anArray | GtOllamaEmbedding new embedding: anArray ])
%

category: 'accessing'
classmethod: GtOllamaEmbeddingsGroup
leJsonV4Name

	^ #gtOllamaEmbeddingsGroup
%

!		Instance methods for 'GtOllamaEmbeddingsGroup'

category: 'accessing'
method: GtOllamaEmbeddingsGroup
client
	^ client
%

category: 'as yet unclassified'
method: GtOllamaEmbeddingsGroup
client: aGtOllamaClient
	client := aGtOllamaClient.
	self items do: [ :anItem | anItem client: aGtOllamaClient ]
%

! Class implementation for 'GtOllamaModelsGroup'

!		Class methods for 'GtOllamaModelsGroup'

category: 'accessing'
classmethod: GtOllamaModelsGroup
from: aDict
	^ self
		withAll: ((aDict at: 'models') collect: [ :aModelDict | GtOllamaModel from: aModelDict ])
%

category: 'accessing'
classmethod: GtOllamaModelsGroup
leJsonV4Name

	^ #gtOllamaModelsGroup
%

!		Instance methods for 'GtOllamaModelsGroup'

category: 'accessing'
method: GtOllamaModelsGroup
client
	^ client
%

category: 'accessing'
method: GtOllamaModelsGroup
client: anObject
	client := anObject.
	
	self do: [ :anItem | anItem client: client ]
%

! Class implementation for 'GtOllamaRunningModelsGroup'

!		Class methods for 'GtOllamaRunningModelsGroup'

category: 'accessing'
classmethod: GtOllamaRunningModelsGroup
from: aDict
	^ self
		withAll: ((aDict at: 'models')
				collect: [ :aModelDict | GtOllamaRunningModel from: aModelDict ])
%

category: 'accessing'
classmethod: GtOllamaRunningModelsGroup
leJsonV4Name

	^ #gtOllamaRunningModelsGroup
%

!		Instance methods for 'GtOllamaRunningModelsGroup'

category: 'accessing'
method: GtOllamaRunningModelsGroup
client
	^ client
%

category: 'accessing'
method: GtOllamaRunningModelsGroup
client: anObject
	client := anObject.
	
	self do: [ :anItem | anItem client: client ]
%

category: 'accessing'
method: GtOllamaRunningModelsGroup
gtModelsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [self items];
		column: 'Name' text: #name;
		column: 'Model' text: #model;
		column: 'VRAM size' text: #sizeVram;
		column: 'Expires at' text: #expiresAt
%

! Class implementation for 'GtOpenAIResourceFilesGroup'

!		Class methods for 'GtOpenAIResourceFilesGroup'

category: 'accessing'
classmethod: GtOpenAIResourceFilesGroup
leJsonV4Name

	^ #gtOpenAIResourceFilesGroup
%

!		Instance methods for 'GtOpenAIResourceFilesGroup'

category: 'accessing'
method: GtOpenAIResourceFilesGroup
gtFilesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ self items ];
		column: 'File' text: #file;
		column: 'Remote ID' text: #remoteId;
		column: 'Description' text: #description
%

category: 'accessing'
method: GtOpenAIResourceFilesGroup
toFileDescriptions
	^ 'Here is a description of the files you have access to:
	
'
		, ({Character lf.
				Character lf} join: (self items collect: #toFileDescription))
%

! Class implementation for 'GtLlmInspectorMethodSummary'

!		Instance methods for 'GtLlmInspectorMethodSummary'

category: 'accessing'
method: GtLlmInspectorMethodSummary
name
	^ name
%

category: 'accessing'
method: GtLlmInspectorMethodSummary
name: anObject
	name := anObject
%

category: 'accessing'
method: GtLlmInspectorMethodSummary
summaryString
	^ self name
%

! Class implementation for 'GtLlmInspectorSlotSummary'

!		Instance methods for 'GtLlmInspectorSlotSummary'

category: 'accessing'
method: GtLlmInspectorSlotSummary
name
	^ name
%

category: 'accessing'
method: GtLlmInspectorSlotSummary
name: anObject
	name := anObject
%

category: 'accessing'
method: GtLlmInspectorSlotSummary
slot
	^ slot
%

category: 'accessing'
method: GtLlmInspectorSlotSummary
slot: anObject
	slot := anObject
%

category: 'accessing'
method: GtLlmInspectorSlotSummary
slotValue
	^ slotValue
%

category: 'accessing'
method: GtLlmInspectorSlotSummary
slotValue: anObject
	slotValue := anObject
%

category: 'accessing'
method: GtLlmInspectorSlotSummary
summaryString
	^ self name , ': '
		, ([ self slotValue asString ] on: Error do: [ '<unknown>' ])
%

! Class implementation for 'GtLlmInspectorSummary'

!		Instance methods for 'GtLlmInspectorSummary'

category: 'accessing'
method: GtLlmInspectorSummary
gtPhlowViewsFor: aView
	<gtView>
	^ aView forward
		title: 'Views';
		priority: 3;
		object: [ self views ];
		view: #gtPhlowViewsFor:
%

category: 'accessing'
method: GtLlmInspectorSummary
gtSlotsFor: aView
	<gtView>
	^ aView forward
		title: 'Slots';
		priority: 2;
		object: [ self slots ];
		view: #gtSlotsFor:
%

category: 'accessing'
method: GtLlmInspectorSummary
gtSummaryFor: aView
	<gtView>
	^ aView textEditor
		title: 'Summary';
		priority: 1;
		text: [ self summaryString ]
%

category: 'accessing'
method: GtLlmInspectorSummary
methods
	^ methods
%

category: 'accessing'
method: GtLlmInspectorSummary
methods: anObject
	methods := anObject
%

category: 'accessing'
method: GtLlmInspectorSummary
object
	^ object
%

category: 'accessing'
method: GtLlmInspectorSummary
object: anObject
	object := anObject
%

category: 'accessing'
method: GtLlmInspectorSummary
objectClass
	^ objectClass
%

category: 'accessing'
method: GtLlmInspectorSummary
objectClass: anObject
	objectClass := anObject
%

category: 'accessing'
method: GtLlmInspectorSummary
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: objectClass asString;
		nextPut: $)
%

category: 'accessing'
method: GtLlmInspectorSummary
slots
	^ slots
%

category: 'accessing'
method: GtLlmInspectorSummary
slots: anObject
	slots := anObject
%

category: 'accessing'
method: GtLlmInspectorSummary
summaryString
	| className article slotSummary viewSummary methodSummary |
	className := self objectClass asString.
	article := className first isVowel ifTrue: [ 'an ' ] ifFalse: [ 'a ' ].

	slotSummary := self slots
			ifEmpty: [ '' ]
			ifNotEmpty: [ 'With slots:' , String cr , String cr
					, (String cr join: (self slots collect: [ :aSlot | aSlot summaryString ])) ].
	methodSummary := self methods
			ifEmpty: [ '' ]
			ifNotEmpty: [ 'With methods:' , String cr , String cr
					, (String cr join: (self methods collect: [ :aSlot | aSlot summaryString ])) ].
	viewSummary := self views
			ifEmpty: [ '' ]
			ifNotEmpty: [ 'With defined views:' , String cr
					, (String cr
							join: (self views collect: [ :aView | String cr , aView summaryString ])) ].

	^ 'an instance of ' , className , String cr , String cr , 'With print string: '
		, self object printString , String cr , String cr , slotSummary , String cr
		, String cr , methodSummary , String cr , String cr , viewSummary
%

category: 'accessing'
method: GtLlmInspectorSummary
views
	^ views
%

category: 'accessing'
method: GtLlmInspectorSummary
views: anObject
	views := anObject
%

! Class implementation for 'GtLlmInstructionPiece'

!		Instance methods for 'GtLlmInstructionPiece'

category: 'accessing'
method: GtLlmInstructionPiece
allParents
	| parents following |
	parents := OrderedCollection new.
	following := self.

	[ following parent isNotNil ]
		whileTrue: [ following := following parent.
			parents add: following ].

	^ parents
%

category: 'accessing'
method: GtLlmInstructionPiece
asInstructionPiece
	^ self
%

category: 'accessing'
method: GtLlmInstructionPiece
children
	^ self subclassResponsibility
%

category: 'accessing'
method: GtLlmInstructionPiece
gtParentsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Parents';
		priority: 3;
		items: [ self allParents withIndexCollect: [:aParent :i | i -> aParent] ];
		column: 'Position' text: #key width: 60;
		column: 'Parent' text: #value
%

category: 'accessing'
method: GtLlmInstructionPiece
instructionString
	^ self subclassResponsibility
%

category: 'accessing'
method: GtLlmInstructionPiece
parent
	^ parent
%

category: 'accessing'
method: GtLlmInstructionPiece
parent: anObject
	parent := anObject.

	self source ifNil: [ self source: parent source ]
%

category: 'accessing'
method: GtLlmInstructionPiece
source
	^ source
%

category: 'accessing'
method: GtLlmInstructionPiece
source: anObject
	source := anObject
%

category: 'as yet unclassified'
method: GtLlmInstructionPiece
title
	^ ''
%

! Class implementation for 'GtLlmInstructionComposite'

!		Class methods for 'GtLlmInstructionComposite'

category: 'other'
classmethod: GtLlmInstructionComposite
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmInstructionComposite'

category: 'accessing'
method: GtLlmInstructionComposite
addItem: anItem
	items add: (anItem asInstructionPiece parent: self)
%

category: 'accessing'
method: GtLlmInstructionComposite
children
	^ items
%

category: 'accessing'
method: GtLlmInstructionComposite
gtDisplayOn: stream
	stream nextPutAll: '--Composite--'
%

category: 'accessing'
method: GtLlmInstructionComposite
initialize
	super initialize.
	
	items := OrderedCollection new
%

category: 'accessing'
method: GtLlmInstructionComposite
instructionString
	^ (String cr, String cr) join: (items collect: [:anItem | anItem instructionString])
%

category: 'accessing'
method: GtLlmInstructionComposite
items: anObject
	items := anObject
			collect: [ :anInstruction | anInstruction asInstructionPiece parent: self ]
%

! Class implementation for 'GtLlmInstructionList'

!		Class methods for 'GtLlmInstructionList'

category: 'other'
classmethod: GtLlmInstructionList
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmInstructionList'

category: 'accessing'
method: GtLlmInstructionList
addItem: anItem
	items add: (anItem asInstructionPiece parent: self)
%

category: 'accessing'
method: GtLlmInstructionList
children
	^ items
%

category: 'accessing'
method: GtLlmInstructionList
gtDisplayOn: stream
	stream nextPutAll: '--List--'
%

category: 'accessing'
method: GtLlmInstructionList
initialize
	super initialize.
	
	items := OrderedCollection new
%

category: 'accessing'
method: GtLlmInstructionList
instructionString
	^ Character cr
		join: (self items collect: [ :anItem | '- ' , anItem instructionString ])
%

category: 'accessing'
method: GtLlmInstructionList
items
	^ items
%

category: 'accessing'
method: GtLlmInstructionList
items: anObject
	items := anObject collect: #asInstructionPiece
%

! Class implementation for 'GtLlmInstructionSection'

!		Class methods for 'GtLlmInstructionSection'

category: 'other'
classmethod: GtLlmInstructionSection
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmInstructionSection'

category: 'accessing'
method: GtLlmInstructionSection
body
	^ body
%

category: 'accessing'
method: GtLlmInstructionSection
body: anObject
	body := anObject asInstructionPiece parent: self
%

category: 'accessing'
method: GtLlmInstructionSection
children
	^ {body}
%

category: 'accessing'
method: GtLlmInstructionSection
computeHeaderLevelsAutomatically
	autoHeaderLevel := true
%

category: 'accessing'
method: GtLlmInstructionSection
doNotComputeHeaderLevelsAutomatically
	autoHeaderLevel := false
%

category: 'accessing'
method: GtLlmInstructionSection
gtDisplayOn: aStream
	aStream
		nextPutAll: self title
%

category: 'accessing'
method: GtLlmInstructionSection
headerLevel
	autoHeaderLevel
		ifTrue: [ ^ (self allParents
				select: [ :aParent | aParent isKindOf: GtLlmInstructionSection ]) size + 1 ].
	^ headerLevel
%

category: 'accessing'
method: GtLlmInstructionSection
headerLevel: anObject
	self
		assert: autoHeaderLevel not
		description: 'Cannot set header level because it is automatically generated. Use #doNotComputeHeaderLevelsAutomatically to disable.'.
	self assert: anObject > 0.

	headerLevel := anObject
%

category: 'accessing'
method: GtLlmInstructionSection
initialize
	super initialize.
	
	headerLevel := 1.
	autoHeaderLevel := true.
%

category: 'accessing'
method: GtLlmInstructionSection
instructionString
	^ ('#' repeat: self headerLevel) , ' ' , self title
		, String cr , self body instructionString
%

category: 'accessing'
method: GtLlmInstructionSection
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self title;
		nextPut: $)
%

category: 'accessing'
method: GtLlmInstructionSection
title
	^ title
%

category: 'accessing'
method: GtLlmInstructionSection
title: anObject
	title := anObject
%

! Class implementation for 'GtLlmInstructionString'

!		Instance methods for 'GtLlmInstructionString'

category: 'accessing'
method: GtLlmInstructionString
children
	^ {}
%

category: 'accessing'
method: GtLlmInstructionString
gtDisplayOn: aStream
	aStream
		nextPutAll: string
%

category: 'accessing'
method: GtLlmInstructionString
instructionString
	^ string
%

category: 'accessing'
method: GtLlmInstructionString
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: string;
		nextPut: $)
%

category: 'accessing'
method: GtLlmInstructionString
string
	^ string
%

category: 'accessing'
method: GtLlmInstructionString
string: anObject
	string := anObject
%

! Class implementation for 'GtLlmInstructionWithSections'

!		Instance methods for 'GtLlmInstructionWithSections'

category: 'accessing'
method: GtLlmInstructionWithSections
addSection: aSection
	sections add: (aSection asInstructionPiece parent: self)
%

category: 'accessing'
method: GtLlmInstructionWithSections
addSections: aListOfSections
	sections
		addAll: (aListOfSections collect: [ :aSection | aSection asInstructionPiece parent: self ])
%

category: 'accessing'
method: GtLlmInstructionWithSections
children
	^ {introduction} , sections
%

category: 'accessing'
method: GtLlmInstructionWithSections
gtDisplayOn: aStream
	aStream
		nextPutAll: self introduction instructionString
%

category: 'accessing'
method: GtLlmInstructionWithSections
initialize
	super initialize.
	
	sections := OrderedCollection new
%

category: 'accessing'
method: GtLlmInstructionWithSections
instructionString
	^ self introduction instructionString
		, '
	
'
		, ('
			
' join: (self sections collect: [ :aSection | aSection instructionString ]))
%

category: 'accessing'
method: GtLlmInstructionWithSections
introduction
	^ introduction
%

category: 'accessing'
method: GtLlmInstructionWithSections
introduction: anObject
	introduction := anObject asInstructionPiece
%

category: 'accessing'
method: GtLlmInstructionWithSections
printOn: aStream
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self introduction instructionString;
		nextPut: $)
%

category: 'accessing'
method: GtLlmInstructionWithSections
sections
	^ sections
%

category: 'accessing'
method: GtLlmInstructionWithSections
sections: anObject
	sections := anObject asOrderedCollection
			collect: [ :aSection | aSection asInstructionPiece parent: self ]
%

! Class implementation for 'GtLlmMessagePart'

!		Instance methods for 'GtLlmMessagePart'

category: 'as yet unclassified'
method: GtLlmMessagePart
isString
	^ false
%

category: 'as yet unclassified'
method: GtLlmMessagePart
serialize
	^ self subclassResponsibility
%

category: 'as yet unclassified'
method: GtLlmMessagePart
serializeInline
	^ self subclassResponsibility
%

category: 'as yet unclassified'
method: GtLlmMessagePart
type
	^ self subclassResponsibility
%

! Class implementation for 'GtLlmFileMessagePart'

!		Instance methods for 'GtLlmFileMessagePart'

category: 'as yet unclassified'
method: GtLlmFileMessagePart
content
	^ self fileId
%

category: 'accessing'
method: GtLlmFileMessagePart
file
	^ file
%

category: 'accessing'
method: GtLlmFileMessagePart
file: anObject
	file := anObject
%

category: 'accessing'
method: GtLlmFileMessagePart
fileId
	^ fileId
%

category: 'accessing'
method: GtLlmFileMessagePart
fileId: anObject
	fileId := anObject
%

category: 'as yet unclassified'
method: GtLlmFileMessagePart
serialize
	^ {'type' -> 'image_file'.
		'image_file' -> {'file_id' -> self fileId} asDictionary} asDictionary
%

category: 'as yet unclassified'
method: GtLlmFileMessagePart
serializeInline
	^ {'type' -> 'image_url'.
		'image_url'
			-> {'url' -> ('data:image/png;base64,' , self file binaryContents base64Encoded)}
					asDictionary} asDictionary
%

category: 'as yet unclassified'
method: GtLlmFileMessagePart
type
	^ 'File'
%

! Class implementation for 'GtLlmStringMessagePart'

!		Instance methods for 'GtLlmStringMessagePart'

category: 'as yet unclassified'
method: GtLlmStringMessagePart
content
	^ self string
%

category: 'as yet unclassified'
method: GtLlmStringMessagePart
isString
	^ true
%

category: 'as yet unclassified'
method: GtLlmStringMessagePart
serialize
	^ {'type' -> 'text'.
		'text' -> self string} asDictionary
%

category: 'as yet unclassified'
method: GtLlmStringMessagePart
serializeInline
	^ self serialize
%

category: 'accessing'
method: GtLlmStringMessagePart
string
	^ string
%

category: 'accessing'
method: GtLlmStringMessagePart
string: anObject
	string := anObject
%

category: 'as yet unclassified'
method: GtLlmStringMessagePart
type
	^ 'String'
%

! Class implementation for 'GtLlmMessageSerializer'

!		Class methods for 'GtLlmMessageSerializer'

category: 'accessing'
classmethod: GtLlmMessageSerializer
leJsonV4Name

	^ #gtLlmMessageSerializer
%

!		Instance methods for 'GtLlmMessageSerializer'

category: 'as yet unclassified'
method: GtLlmMessageSerializer
instance
	^ nil
%

category: 'as yet unclassified'
method: GtLlmMessageSerializer
serialize: aString
	^ aString
%

! Class implementation for 'GtLlmActionMessageSerializer'

!		Class methods for 'GtLlmActionMessageSerializer'

category: 'accessing'
classmethod: GtLlmActionMessageSerializer
leJsonV4Name

	^ #gtLlmActionMessageSerializer
%

!		Instance methods for 'GtLlmActionMessageSerializer'

category: 'as yet unclassified'
method: GtLlmActionMessageSerializer
serialize: aCall
	| associations |
	associations := {'Action' -> aCall action.
			'Arguments' -> aCall arguments}.
	^ STONJSON toString: associations asDictionary
%

! Class implementation for 'GtLlmActionMessageWithInstanceSerializer'

!		Class methods for 'GtLlmActionMessageWithInstanceSerializer'

category: 'accessing'
classmethod: GtLlmActionMessageWithInstanceSerializer
leJsonV4Name

	^ #gtLlmActionMessageWithInstanceSerializer
%

!		Instance methods for 'GtLlmActionMessageWithInstanceSerializer'

category: 'as yet unclassified'
method: GtLlmActionMessageWithInstanceSerializer
gtInstanceFor: aView
	<gtView>
	self instance ifNil: [ ^ aView empty ].
	self gtDo: [] gemstoneDo: [ ^ aView empty ].

	^ aView forward
		title: 'Instance';
		priority: 1;
		object: [ self instance ];
		view: #gtLiveFor:
%

category: 'accessing'
method: GtLlmActionMessageWithInstanceSerializer
instance
	^ instance
%

category: 'accessing'
method: GtLlmActionMessageWithInstanceSerializer
instance: anObject
	instance := anObject
%

category: 'as yet unclassified'
method: GtLlmActionMessageWithInstanceSerializer
serialize: aMessage
	^ STONJSON
		toString: ({'Action' -> aMessage action.
				'Arguments' -> (aMessage arguments collect: #asString)}
				, self instance serialize asOrderedCollection) asDictionary
%

category: 'as yet unclassified'
method: GtLlmActionMessageWithInstanceSerializer
update: aValue
	self instance updateContent: aValue
%

! Class implementation for 'GtLlmModelFile'

!		Class methods for 'GtLlmModelFile'

category: 'other'
classmethod: GtLlmModelFile
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmModelFile'

category: 'accessing'
method: GtLlmModelFile
adapter: aString 
	self addDirective: (GtLlmAdapterDirective withText: aString)
%

category: 'accessing'
method: GtLlmModelFile
addDirective: aDirective
	directives add: aDirective
%

category: 'accessing'
method: GtLlmModelFile
addMessage: aMessage
	self
		addDirective: ((GtLlmMessageDirective withText: aMessage role)
				messageText: aMessage content)
%

category: 'accessing'
method: GtLlmModelFile
content
	^ '

' join: (self directives collect: #directiveString)
%

category: 'accessing'
method: GtLlmModelFile
contentDictionary
	^ (self directives collect: [:aDirective | aDirective directiveAssociation ]) asDictionary
%

category: 'accessing'
method: GtLlmModelFile
directives
	^ directives
%

category: 'accessing'
method: GtLlmModelFile
from: aModel
	self addDirective: (GtLlmFromDirective withText: aModel)
%

category: 'accessing'
method: GtLlmModelFile
gtContentFor: aView
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ]
%

category: 'accessing'
method: GtLlmModelFile
gtDirectivesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Directives';
		priority: 2;
		items: [ self directives ];
		column: 'Kind' text: #directiveKind;
		column: 'Text' text: #directiveText
%

category: 'accessing'
method: GtLlmModelFile
initialize
	directives := OrderedCollection new
%

category: 'accessing'
method: GtLlmModelFile
license: aString
	self addDirective: (GtLlmLicenseDirective withText: aString)
%

category: 'accessing'
method: GtLlmModelFile
messageFrom: aString withText: aText
	self
		addDirective: ((GtLlmMessageDirective withText: aString) messageText: aText)
%

category: 'accessing'
method: GtLlmModelFile
parameter: aString at: anObject
	self
		addDirective: ((GtLlmParameterDirective withText: aString) value: anObject)
%

category: 'accessing'
method: GtLlmModelFile
system: aModel
	self addDirective: (GtLlmSystemDirective withText: aModel)
%

category: 'accessing'
method: GtLlmModelFile
template: aString 
	self addDirective: (GtLlmTemplateDirective withText: aString)
%

! Class implementation for 'GtLlmModelfileDirective'

!		Class methods for 'GtLlmModelfileDirective'

category: 'accessing'
classmethod: GtLlmModelfileDirective
withText: aString
	^ self new text: aString
%

!		Instance methods for 'GtLlmModelfileDirective'

category: 'as yet unclassified'
method: GtLlmModelfileDirective
directiveAssociation
	^ self directiveKind asLowercase -> self directiveText
%

category: 'accessing'
method: GtLlmModelfileDirective
directiveKind
	^ self subclassResponsibility
%

category: 'accessing'
method: GtLlmModelfileDirective
directiveString
	^ self directiveKind, ' ', self directiveText
%

category: 'accessing'
method: GtLlmModelfileDirective
directiveText
	^ self treatText
%

category: 'accessing'
method: GtLlmModelfileDirective
text
	^ text
%

category: 'accessing'
method: GtLlmModelfileDirective
text: anObject
	text := anObject
%

category: 'accessing'
method: GtLlmModelfileDirective
treatText
	"a hook to enable custom text treatment. default: quoting"
	^ '"""', self text, '"""'
%

! Class implementation for 'GtLlmAdapterDirective'

!		Instance methods for 'GtLlmAdapterDirective'

category: 'accessing'
method: GtLlmAdapterDirective
directiveKind
	^ 'ADAPTER'
%

category: 'accessing'
method: GtLlmAdapterDirective
treatText
	^ self text
%

! Class implementation for 'GtLlmFromDirective'

!		Instance methods for 'GtLlmFromDirective'

category: 'accessing'
method: GtLlmFromDirective
directiveKind
	^ 'FROM'
%

category: 'accessing'
method: GtLlmFromDirective
treatText
	^ self text
%

! Class implementation for 'GtLlmLicenseDirective'

!		Instance methods for 'GtLlmLicenseDirective'

category: 'accessing'
method: GtLlmLicenseDirective
directiveKind
	^ 'LICENSE'
%

! Class implementation for 'GtLlmMessageDirective'

!		Instance methods for 'GtLlmMessageDirective'

category: 'accessing'
method: GtLlmMessageDirective
directiveKind
	^ 'MESSAGE'
%

category: 'accessing'
method: GtLlmMessageDirective
messageText
	^ messageText
%

category: 'accessing'
method: GtLlmMessageDirective
messageText: anObject
	messageText := anObject
%

category: 'accessing'
method: GtLlmMessageDirective
treatText
	^ self text, ' """', self messageText, '"""'
%

! Class implementation for 'GtLlmParameterDirective'

!		Instance methods for 'GtLlmParameterDirective'

category: 'accessing'
method: GtLlmParameterDirective
directiveKind
	^ 'PARAMETER'
%

category: 'accessing'
method: GtLlmParameterDirective
treatText
	^ self text , ' ' , self value asString
%

category: 'accessing'
method: GtLlmParameterDirective
value
	^ value
%

category: 'accessing'
method: GtLlmParameterDirective
value: anObject
	value := anObject
%

! Class implementation for 'GtLlmSystemDirective'

!		Instance methods for 'GtLlmSystemDirective'

category: 'accessing'
method: GtLlmSystemDirective
directiveKind
	^ 'SYSTEM'
%

! Class implementation for 'GtLlmTemplateDirective'

!		Instance methods for 'GtLlmTemplateDirective'

category: 'accessing'
method: GtLlmTemplateDirective
directiveKind
	^ 'TEMPLATE'
%

! Class implementation for 'GtLlmNearestEmbedding'

!		Instance methods for 'GtLlmNearestEmbedding'

category: 'accessing'
method: GtLlmNearestEmbedding
distance
	^ distance
%

category: 'accessing'
method: GtLlmNearestEmbedding
distance: anObject
	distance := anObject
%

category: 'accessing'
method: GtLlmNearestEmbedding
embedding
	^ embedding
%

category: 'accessing'
method: GtLlmNearestEmbedding
embedding: anObject
	embedding := anObject
%

category: 'accessing'
method: GtLlmNearestEmbedding
input
	^ self embedding input
%

! Class implementation for 'GtLlmNewThreadMessage'

!		Instance methods for 'GtLlmNewThreadMessage'

category: 'accessing'
method: GtLlmNewThreadMessage
actions
	^ assistantChat assistant actions
%

category: 'as yet unclassified'
method: GtLlmNewThreadMessage
addFile: aFileReference
	files add: aFileReference
%

category: 'accessing'
method: GtLlmNewThreadMessage
annotations
	^ {} asDictionary
%

category: 'accessing'
method: GtLlmNewThreadMessage
assistantChat
	^ assistantChat
%

category: 'accessing'
method: GtLlmNewThreadMessage
assistantChat: anAssistantChat
	assistantChat := anAssistantChat
%

category: 'as yet unclassified'
method: GtLlmNewThreadMessage
beSync
	isSync := true
%

category: 'accessing'
method: GtLlmNewThreadMessage
contents
	^ contents
%

category: 'accessing'
method: GtLlmNewThreadMessage
contents: anObject
	contents := anObject
%

category: 'accessing'
method: GtLlmNewThreadMessage
contents: aString requester: aRequester
	contents := aString.
	self onContentsChangeByRequester: aRequester
%

category: 'accessing'
method: GtLlmNewThreadMessage
contentSummary
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
%

category: 'accessing'
method: GtLlmNewThreadMessage
contentText
	^ self contents
%

category: 'as yet unclassified'
method: GtLlmNewThreadMessage
files
	^ files
%

category: 'as yet unclassified'
method: GtLlmNewThreadMessage
future
	^ future
%

category: 'accessing'
method: GtLlmNewThreadMessage
id
	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
%

category: 'initialization'
method: GtLlmNewThreadMessage
initialize
	super initialize.
	contents := ''.
	announcer := Announcer new.
	files := OrderedCollection new.
	isSync := false.
%

category: 'accessing'
method: GtLlmNewThreadMessage
isAssistantRole
	^ false
%

category: 'private - notifying'
method: GtLlmNewThreadMessage
onContentsChangeByRequester: aRequester
	announcer
		announce: (GtLlmNewThreadMessageContentsChanged new
				threadMessage: self;
				contents: contents;
				requester: aRequester)
%

category: 'actions'
method: GtLlmNewThreadMessage
sendMessage
	| aMessageContent aBlock |
	contents ifNil: [ ^ self ].

	aMessageContent := self treatString.

	self contents: '' requester: nil.

	self files
		ifEmpty: [ aBlock := [ assistantChat sendMessage: aMessageContent ] ]
		ifNotEmpty: [ assistantChat sendFiles: files withMessage: aMessageContent ].

	files := OrderedCollection new.

	isSync
		ifTrue: [ aBlock value ]
		ifFalse: [ future := aBlock asAsyncPromise
					then: [  ]
					otherwise: [ :anError | anError inspect ] ]
%

category: 'actions'
method: GtLlmNewThreadMessage
treatString
	^ contents
%

category: 'subscriptions'
method: GtLlmNewThreadMessage
unsubscribe: anObject
	^ announcer unsubscribe: anObject
%

category: 'subscriptions'
method: GtLlmNewThreadMessage
when: anEventSelector send: aMessageSelector to: anObject
	^ announcer weak
		when: anEventSelector
		send: aMessageSelector
		to: anObject
%

! Class implementation for 'GtLlmNewActionThreadMessage'

!		Instance methods for 'GtLlmNewActionThreadMessage'

category: 'accessing'
method: GtLlmNewActionThreadMessage
currentAction
	^ currentAction
%

category: 'accessing'
method: GtLlmNewActionThreadMessage
currentAction: anObject
	currentAction := anObject
%

category: 'as yet unclassified'
method: GtLlmNewActionThreadMessage
treatString
	^ GtLlmActionCall new
		action: currentAction name;
		arguments: (currentAction hasArgument ifTrue: [ {contents asString} ] ifFalse: [ {} ])
%

! Class implementation for 'GtLlmNullConnection'

!		Instance methods for 'GtLlmNullConnection'

category: 'as yet unclassified'
method: GtLlmNullConnection
buildProvider
	^ GtLlmNullProvider new
%

! Class implementation for 'GtLlmPharoObjectSummarizer'

!		Instance methods for 'GtLlmPharoObjectSummarizer'

category: 'accessing'
method: GtLlmPharoObjectSummarizer
guessPackagePrefixes: aPackage
	| definedClasses possiblePrefixes amountOfClasses |
	definedClasses := aPackage definedClasses.
	amountOfClasses := definedClasses size.

	amountOfClasses isZero ifTrue: [ ^ #() ].

	possiblePrefixes := ((((definedClasses
			collect: [ :each | each name gtPiecesCutWhereCamelCase ]
			thenSelect: [ :each | each size > 1 ])
			collect: [ :each | each first ] as: Array)
			select: [ :each | (aPackage includesClassNamed: each) not ])
			groupedBy: #yourself) collect: #size.

	possiblePrefixes := possiblePrefixes
			collect: [ :each | (each / amountOfClasses) asFloat ].

	possiblePrefixes := possiblePrefixes associations
			select: [ :each | each key size <= 2 or: [ each value > 0.2 ] ]
			thenCollect: [ :each | each key ].

	^ possiblePrefixes asSet
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
shortCollectionName: aCollection on: aStream
	| aClassName theNamePieces anArticle |
	
	aClassName := aCollection class name.
	theNamePieces := aClassName gtPiecesCutWhereCamelCase.
	anArticle := theNamePieces first first isVowel
		ifTrue: [ 'an' ]
		ifFalse: [ 'a' ].
	
	aStream
		nextPutAll: anArticle;
		space.

	theNamePieces
		do: [ :each | aStream nextPutAll: each asLowercase ]
		separatedBy: [ aStream space ]
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
shortPluralClassName: aClass on: aStream
	| aClassName theNamePieces |
	
	aClassName := aClass name.
	theNamePieces := aClassName gtPiecesCutWhereCamelCase.
	theNamePieces at: theNamePieces size put: (theNamePieces last asEnglishPlural).
	
	theNamePieces
		do: [ :each | aStream nextPutAll: each asLowercase ]
		separatedBy: [ aStream space ]
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
summarize: anObject
	^ String streamContents: [ :aStream | self summarize: anObject on: aStream ]
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
summarize: anObject on: aStream
	self
		summarize: anObject
		on: aStream
		includingSlots: true
		includingInstanceOf: true
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
summarize: anObject on: aStream includingSlots: shouldIncludeSlots includingInstanceOf: shouldIncludeAnInstanceOf
	anObject isCollection
		ifTrue: [ ^ self summarizeCollection: anObject on: aStream ].

	self
		summarizeObject: anObject
		on: aStream
		includingSlots: shouldIncludeSlots
		includingInstanceOf: shouldIncludeAnInstanceOf
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
summarizeCollection: aCollection on: aStream
	| theItemTypes maxItemTypes |
	self shortCollectionName: aCollection on: aStream.

	theItemTypes := (aCollection collect: [ :each |
		each isClass
			ifTrue: [ Class ]
			ifFalse: [ each class ] ] as: Set) asArray
			sorted: [ :a :b | a class name < b class name ].

	theItemTypes ifEmpty: [ ^ self ].

	aStream
		space;
		nextPutAll: 'of';
		space.

	maxItemTypes := 8.
		
	1
		to: (theItemTypes size min: maxItemTypes)
		do: [ :index | 
			(index > 1 and: [ index < theItemTypes size ])
				ifTrue: [ aStream
						nextPut: $,;
						space ].
			(index > 1 and: [ index = theItemTypes size ])
				ifTrue: [ aStream
						space;
						nextPutAll: 'and';
						space ].

			self shortPluralClassName: (theItemTypes at: index) on: aStream ].
	
	theItemTypes size > maxItemTypes
		ifTrue: [ aStream space; nextPutAll: 'and others' ].
%

category: 'accessing'
method: GtLlmPharoObjectSummarizer
summarizeObject: anObject on: aStream includingSlots: shouldIncludeSlots includingInstanceOf: shouldIncludeAnInstanceOf
	| aClassName theNamePieces anArticle theSlots |

	aClassName := anObject class name.
	theNamePieces := aClassName gtPiecesCutWhereCamelCase.

	shouldIncludeAnInstanceOf
		ifTrue: [
			aStream
				nextPutAll: 'an instance of';
				space ].
		
	anArticle := theNamePieces first first isVowel
		ifTrue: [ 'an' ]
		ifFalse: [ 'a' ].
	
	aStream
		nextPutAll: anArticle;
		space.

	theNamePieces
		do: [ :each | aStream nextPutAll: each asLowercase ]
		separatedBy: [ aStream space ].
		
	shouldIncludeSlots
		ifFalse: [ ^ self ].

	theSlots := anObject class allSlots.
	theSlots ifEmpty: [ ^ self ].
	
	aStream space; nextPutAll: 'made of'; space.
	
	1
		to: theSlots size
		do: [ :index | 
			| eachSlot |
			(index > 1 and: [ index < theSlots size ])
				ifTrue: [ aStream
						nextPut: $,;
						space ].
			(index > 1 and: [ index = theSlots size ])
				ifTrue: [ aStream
						space;
						nextPutAll: 'and';
						space ].
			
			eachSlot := theSlots at: index.
			
			aStream
				nextPut: $";
				nextPutAll: eachSlot name;
				nextPut: $" ].

	aStream nextPut: $,; space; nextPutAll: 'where'; space.
	
	1
		to: theSlots size
		do: [ :index | 
			| eachSlot |
			(index > 1 and: [ index < theSlots size ])
				ifTrue: [ aStream
						nextPut: $,;
						space ].
			(index > 1 and: [ index = theSlots size ])
				ifTrue: [ aStream
						space;
						nextPutAll: 'and';
						space ].
			
			eachSlot := theSlots at: index.
			
			aStream
				nextPut: $";
				nextPutAll: eachSlot name;
				nextPut: $";
				space;
				nextPutAll: 'is';
				space.

			self
				summarize: (eachSlot read: anObject)
				on: aStream
				includingSlots: false
				includingInstanceOf: false ].
%

! Class implementation for 'GtLlmProvider'

!		Class methods for 'GtLlmProvider'

category: 'as yet unclassified'
classmethod: GtLlmProvider
defaultProviders
	^ self allSubclasses
		select: [ :aSubclass | aSubclass class canUnderstand: #default ]
%

category: 'as yet unclassified'
classmethod: GtLlmProvider
isConnectable
	^ false
%

category: 'as yet unclassified'
classmethod: GtLlmProvider
new
	^ self basicNew initialize
%

!		Instance methods for 'GtLlmProvider'

category: 'as yet unclassified'
method: GtLlmProvider
addBrowseTool
%

category: 'accessing'
method: GtLlmProvider
assistantMessageClass
	^ assistantMessageClass
		ifNil: [ assistantMessageClass := self defaultAssistantMessageClass ]
%

category: 'accessing'
method: GtLlmProvider
assistantMessageClass: anObject
	assistantMessageClass := anObject
%

category: 'accessing'
method: GtLlmProvider
chat
	^ chat
%

category: 'accessing'
method: GtLlmProvider
chat: anObject
	chat := anObject
%

category: 'as yet unclassified'
method: GtLlmProvider
client
	^ self subclassResponsibility
%

category: 'as yet unclassified'
method: GtLlmProvider
defaultAssistantMessageClass
	^ GtLlmAssistantMessage
%

category: 'as yet unclassified'
method: GtLlmProvider
defaultUserMessageClass
	^ GtLlmUserMessage
%

category: 'accessing'
method: GtLlmProvider
format
	^ format
%

category: 'accessing'
method: GtLlmProvider
format: anObject
	format := anObject
%

category: 'as yet unclassified'
method: GtLlmProvider
gtCallsFor: aView
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 1;
		object: [ self client ];
		view: #gtCallsFor:
%

category: 'as yet unclassified'
method: GtLlmProvider
sendAssistantMessage: anObject 
	^ self subclassResponsibility
%

category: 'as yet unclassified'
method: GtLlmProvider
sendMessage: aMessage
	self
		sendAssistantMessage: (self userMessageClass new
				content: aMessage;
				role: 'user';
				chat: self)
%

category: 'as yet unclassified'
method: GtLlmProvider
status
	^ self subclassResponsibility
%

category: 'accessing'
method: GtLlmProvider
userMessageClass
	^ userMessageClass ifNil: [ userMessageClass := self defaultUserMessageClass ]
%

category: 'accessing'
method: GtLlmProvider
userMessageClass: anObject
	userMessageClass := anObject
%

! Class implementation for 'GtLlmNullProvider'

!		Class methods for 'GtLlmNullProvider'

category: 'as yet unclassified'
classmethod: GtLlmNullProvider
default
	^ self new
%

category: 'as yet unclassified'
classmethod: GtLlmNullProvider
isConnectable
	^ true
%

!		Instance methods for 'GtLlmNullProvider'

category: 'as yet unclassified'
method: GtLlmNullProvider
client
	^ nil
%

category: 'as yet unclassified'
method: GtLlmNullProvider
format: aFormat
%

category: 'as yet unclassified'
method: GtLlmNullProvider
instructions: aString
%

category: 'as yet unclassified'
method: GtLlmNullProvider
model
	^ nil
%

category: 'as yet unclassified'
method: GtLlmNullProvider
model: aModelName
%

category: 'as yet unclassified'
method: GtLlmNullProvider
modelName
	^ 'Null'
%

category: 'as yet unclassified'
method: GtLlmNullProvider
printOn: aStream
	aStream
		nextPutAll: 'Null'
%

category: 'as yet unclassified'
method: GtLlmNullProvider
sendMessage: aMessage
	self chat addMessage: (GtLlmUserMessage new content: aMessage)
%

category: 'as yet unclassified'
method: GtLlmNullProvider
status
	^ GtLlmAssistantChatReadyStatus new
%

category: 'as yet unclassified'
method: GtLlmNullProvider
tools: aGtLlmToolsGroup 
	"do nothing"
%

! Class implementation for 'GtLlmStaticProvider'

!		Instance methods for 'GtLlmStaticProvider'

category: 'as yet unclassified'
method: GtLlmStaticProvider
initialize
	super initialize.
	
	index := 1.
	messages := {}
%

category: 'accessing'
method: GtLlmStaticProvider
messages
	^ messages
%

category: 'accessing'
method: GtLlmStaticProvider
messages: anObject
	messages := anObject
%

category: 'as yet unclassified'
method: GtLlmStaticProvider
nextMessage
	| message |
	index > messages size ifTrue: [ ^ String loremIpsum ].

	message := messages at: index.

	index := index + 1.

	^ message
%

category: 'as yet unclassified'
method: GtLlmStaticProvider
printOn: aStream
	aStream
		nextPutAll: 'Static'
%

category: 'as yet unclassified'
method: GtLlmStaticProvider
sendMessage: aMessage
	self chat
		addMessage: (self userMessageClass new
				role: 'user';
				content: aMessage).

	self chat
		addMessage: (self assistantMessageClass new
				role: 'assistant';
				content: self nextMessage).
				
	self chat signalRunIsDone
%

! Class implementation for 'GtOllamaProvider'

!		Class methods for 'GtOllamaProvider'

category: 'as yet unclassified'
classmethod: GtOllamaProvider
default
	^ [ self new model: self defaultModel ]
%

category: 'as yet unclassified'
classmethod: GtOllamaProvider
defaultModel
	^ DefaultModel ifNil: [ DefaultModel := 'llama3.1' ]
%

category: 'as yet unclassified'
classmethod: GtOllamaProvider
initialize
	IsConnectable := false
%

category: 'as yet unclassified'
classmethod: GtOllamaProvider
markConnectable
	IsConnectable := true
%

category: 'as yet unclassified'
classmethod: GtOllamaProvider
markNonconnectable
	IsConnectable := false
%

category: 'as yet unclassified'
classmethod: GtOllamaProvider
providerName
	^ 'Ollama'
%

!		Instance methods for 'GtOllamaProvider'

category: 'as yet unclassified'
method: GtOllamaProvider
addTool: aTool
	tools add: aTool
%

category: 'as yet unclassified'
method: GtOllamaProvider
baseUrl: aUrl
	self client baseUrl: aUrl
%

category: 'accessing'
method: GtOllamaProvider
client
	^ client
%

category: 'accessing'
method: GtOllamaProvider
client: anObject
	client := anObject
%

category: 'as yet unclassified'
method: GtOllamaProvider
defaultAssistantMessageClass
	^ self chat messageClassForOllama
%

category: 'as yet unclassified'
method: GtOllamaProvider
defaultUserMessageClass
	^ self chat messageClassForOllama
%

category: 'as yet unclassified'
method: GtOllamaProvider
executions
	^ executions
%

category: 'accessing'
method: GtOllamaProvider
files
	^ files
%

category: 'accessing'
method: GtOllamaProvider
files: anObject
	files := anObject
%

category: 'as yet unclassified'
method: GtOllamaProvider
gtToolsFor: aView
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 5;
		object: [ tools ];
		view: #gtItemsFor:
%

category: 'as yet unclassified'
method: GtOllamaProvider
initialize
	super initialize.

	assistantWorking := false.
	executions := OrderedCollection new.
	
	self initializeClient.
	
	tools := GtLlmToolsGroup new
%

category: 'as yet unclassified'
method: GtOllamaProvider
initializeClient
	client := GtOllamaClient new
%

category: 'as yet unclassified'
method: GtOllamaProvider
instructions
	^ instructions
%

category: 'as yet unclassified'
method: GtOllamaProvider
instructions: aString
	instructions := aString
%

category: 'accessing'
method: GtOllamaProvider
model
	^ model
%

category: 'accessing'
method: GtOllamaProvider
model: anObject
	model := anObject.
	
	"ignore pulling errors that occur on local models. worst case is we’ll get an issue later when trying to chat"
	[ self client pullModel: model ] on: Error do: [  ]
%

category: 'as yet unclassified'
method: GtOllamaProvider
modelName
	^ self model
%

category: 'as yet unclassified'
method: GtOllamaProvider
performToolCallsFor: aResult
	aResult toolCalls
		do: [ :aToolCall | 
			| toolOutput |
			toolOutput := tools performToolCall: aToolCall.
			chat
				addMessage: (GtLlmToolMessage new
						toolCall: aToolCall;
						output: toolOutput) ].
	self chat signalRunHasUpdated
%

category: 'as yet unclassified'
method: GtOllamaProvider
printOn: aStream
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self modelName;
		nextPut: $)
%

category: 'as yet unclassified'
method: GtOllamaProvider
sendAssistantMessage: aMessage
    | userMessage |
	userMessage := self userMessageClass new merge: aMessage.
	userMessage role: 'user'.
	self chat addMessage: userMessage.

	self asyncWait
%

category: 'as yet unclassified'
method: GtOllamaProvider
sendFiles: aCollection withMessage: aString
	| userMessage |
	userMessage := self userMessageClass new
			content: aString;
			images: (aCollection collect: [ :aFile | aFile binaryContents base64Encoded ]);
			role: 'user';
			chat: self.

	self chat addMessage: userMessage.

	self asyncWait
%

category: 'as yet unclassified'
method: GtOllamaProvider
status
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
%

category: 'accessing'
method: GtOllamaProvider
tools
	^ tools
%

category: 'accessing'
method: GtOllamaProvider
tools: anObject
	tools := anObject
%

category: 'as yet unclassified'
method: GtOllamaProvider
triggerAssistant
	| result |
	assistantWorking := true.

	self chat signalRunHasStarted.
	[ result := self client
			completeChatWithModel: self model
			andMessages: self chat messages
			andFormat: self format
			andTools: tools
			andInstructions: self instructions.

	self performToolCallsFor: result ] doWhileTrue: [ result toolCalls isNotEmpty ].

	self chat
		addMessage: (self assistantMessageClass new
				content: result content;
				role: 'assistant';
				model: self modelName;
				chat: self;
				rawData: result rawData).

	self chat signalRunIsDone.

	assistantWorking := false
%

! Class implementation for 'GtOpenAIProvider'

!		Class methods for 'GtOpenAIProvider'

category: 'as yet unclassified'
classmethod: GtOpenAIProvider
default
	^ [ self withApiKeyFromFile ]
%

category: 'as yet unclassified'
classmethod: GtOpenAIProvider
isConnectable
	^ GtOpenAIClient apiKeyFile exists
%

category: 'as yet unclassified'
classmethod: GtOpenAIProvider
providerName
	^ 'OpenAI Chat'
%

category: 'as yet unclassified'
classmethod: GtOpenAIProvider
withApiKeyFromFile
	^ self new apiKey: GtOpenAIClient apiKeyFileContents
%

!		Instance methods for 'GtOpenAIProvider'

category: 'as yet unclassified'
method: GtOpenAIProvider
addBrowseTool
	self addTool: (GtLlmTool new type: 'web_search_preview')
%

category: 'accessing'
method: GtOpenAIProvider
apiKey: aString
	client apiKey: aString
%

category: 'accessing'
method: GtOpenAIProvider
chat: anObject
	chat := anObject
%

category: 'as yet unclassified'
method: GtOpenAIProvider
client
	^ client
%

category: 'as yet unclassified'
method: GtOpenAIProvider
defaultAssistantMessageClass
	^ self chat messageClassForOpenAI
%

category: 'as yet unclassified'
method: GtOpenAIProvider
defaultModel
	^ 'gpt-4.1'
%

category: 'as yet unclassified'
method: GtOpenAIProvider
defaultUserMessageClass
	^ self chat messageClassForOpenAI
%

category: 'as yet unclassified'
method: GtOpenAIProvider
initialize
	super initialize.
	
	model := self defaultModel.
	assistantWorking := false.
	
	self initializeClient
%

category: 'as yet unclassified'
method: GtOpenAIProvider
initializeClient
	client := GtOpenAIClient new
%

category: 'as yet unclassified'
method: GtOpenAIProvider
maximumMessageSize
	^ 30000
%

category: 'accessing'
method: GtOpenAIProvider
model
	^ model
%

category: 'accessing'
method: GtOpenAIProvider
model: anObject
	model := anObject
%

category: 'as yet unclassified'
method: GtOpenAIProvider
modelName
	^ model
%

category: 'as yet unclassified'
method: GtOpenAIProvider
printOn: aStream
	aStream
		nextPutAll: self class providerName;
		nextPut: $(;
		nextPutAll: self model;
		nextPut: $)
%

category: 'as yet unclassified'
method: GtOpenAIProvider
sendAssistantMessage: aMessage
	aMessage serializeInline.
	self chat addMessage: aMessage.
	self triggerAssistant
%

category: 'as yet unclassified'
method: GtOpenAIProvider
status
	^ assistantWorking
		ifTrue: [ GtLlmAssistantChatWorkingStatus new ]
		ifFalse: [ GtLlmAssistantChatReadyStatus new ]
%

category: 'as yet unclassified'
method: GtOpenAIProvider
triggerAssistant
	| result |
	self chat signalRunHasStarted.
	assistantWorking := true.

	result := client
			completeChatWithModel: self model
			andMessages: self chat messages.

	self chat
		addMessage: (self assistantMessageClass new
				content: result choices first message content;
				model: self model;
				role: 'assistant').

	assistantWorking := false.
	self chat signalRunIsDone
%

! Class implementation for 'GtOpenAIAssistantProvider'

!		Class methods for 'GtOpenAIAssistantProvider'

category: 'as yet unclassified'
classmethod: GtOpenAIAssistantProvider
providerName
	^ 'OpenAI Assistants'
%

!		Instance methods for 'GtOpenAIAssistantProvider'

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
addFile: aFile
	files add: aFile
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
addTool: aTool
	tools add: aTool
%

category: 'accessing'
method: GtOpenAIAssistantProvider
assistant
	^ assistant
%

category: 'accessing'
method: GtOpenAIAssistantProvider
assistant: anObject
	assistant := anObject
%

category: 'accessing'
method: GtOpenAIAssistantProvider
assistantDescription
	^ assistantDescription
%

category: 'accessing'
method: GtOpenAIAssistantProvider
assistantDescription: anObject
	assistantDescription := anObject
%

category: 'accessing'
method: GtOpenAIAssistantProvider
assistantName
	^ assistantName
%

category: 'accessing'
method: GtOpenAIAssistantProvider
assistantName: anObject
	assistantName := anObject
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
createAssistant
	self assistant ifNotNil: [ self deleteAssistant ].

	files
		do: [ :aFile | 
			apiFiles
				at: (client uploadFile: aFile file withPurpose: 'assistants') id
				put: aFile ].

	assistant := GtOpenAIAssistant new
			model: self model;
			name: self assistantName;
			description: self assistantDescription;
			instructions: self instructions;
			tools: self tools.

	files
		ifNotEmpty: [ assistant
				toolResources: {'file_search'
							-> {'vector_stores' -> {{'file_ids' -> apiFiles keys} asDictionary}} asDictionary}
						asDictionary ].

	assistant := client createAssistant: assistant.

	thread := client createThreadWithMessages: {}.

	self registerForFinalization
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
defaultAssistantDescription
	^ 'An assistant in Glamorous Toolkit.'
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
defaultAssistantName
	^ 'Tutor - ' , FileLocator home basename
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
defaultTools
	^ GtLlmToolsGroup new
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
deleteAssistant
	[ client deleteAssistant: assistant id.
	assistant := nil ] on: GtOpenAIError do: [ assistant := nil ]
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
finalize
	self assistant ifNotNil: [ self deleteAssistant ].

	super finalize
%

category: 'accessing'
method: GtOpenAIAssistantProvider
format: anObject
	format := {'type' -> 'json_schema'.
			'json_schema'
				-> {'name' -> 'ResponseFormat'.
						'strict' -> true.
						'schema' -> anObject} asDictionary} asDictionary
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
getApiFile: anId
	^ apiFiles at: anId
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
getMessages
	^ thread updateMessages
		collect: [ :aThreadMessage | 
			self assistantMessageClass new
				model: self model;
				merge: aThreadMessage ]
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
getRun
	lastRun := client getRun: lastRun id forThread: thread id.

	lastRun isRequiringAction ifTrue: [ lastRun := self performToolCalls ].

	^ lastRun
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
gtFilesFor: aView
	<gtView>
	files ifEmpty: [ ^ aView empty ].

	^ aView forward
		title: 'Files';
		priority: 5;
		object: [ files ];
		view: #gtFilesFor:
%

category: 'views'
method: GtOpenAIAssistantProvider
gtToolsFor: aView
	<gtView>
	^ aView forward
		title: 'Tools';
		object: [ tools ];
		view: #gtItemsFor:
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
initialize
	super initialize.

	assistantName := self defaultAssistantName.
	assistantDescription := self defaultAssistantDescription.
	tools := self defaultTools.
	files := GtOpenAIResourceFilesGroup new.
	apiFiles := Dictionary new
%

category: 'accessing'
method: GtOpenAIAssistantProvider
instructions
	^ instructions
%

category: 'accessing'
method: GtOpenAIAssistantProvider
instructions: anObject
	instructions := anObject.
	
	self createAssistant
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
lastRun
	^ lastRun
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
performToolCalls
	| toolOutputs |
	toolOutputs := lastRun toolCalls
			collect: [ :aToolCall | 
				| toolOutput |
				toolOutput := tools performToolCall: aToolCall.
				chat
					addMessage: (GtLlmToolMessage new
							toolCall: aToolCall;
							output: toolOutput).
				{'tool_call_id' -> aToolCall id.
					'output' -> toolOutput} asDictionary ].

	^ client
		submitToolOutputs: toolOutputs
		toThread: thread id
		anRun: lastRun id
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
sendAssistantMessage: aMessage
	chat addMessage: aMessage.

	chat signalRunHasStarted.

	client addMessage: aMessage toThread: thread id.

	lastRun := client
			createRunForThread: thread id
			usingAssistant: assistant id
			andResponseFormat: self format.

	self updateMessages.

	chat signalRunHasUpdated.

	self executeWait
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
status
	^ GtLlmAssistantChatStatus forLastRun: lastRun
%

category: 'accessing'
method: GtOpenAIAssistantProvider
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIAssistantProvider
tools: anObject
	tools := anObject
%

category: 'as yet unclassified'
method: GtOpenAIAssistantProvider
updateMessages
	| newMessages nonToolMessages |
	newMessages := self getMessages.
	nonToolMessages := chat messages reject: [:aMessage  | aMessage isToolRole].

	newMessages
		doWithIndex: [ :aMessage :anIndex | 
			anIndex > nonToolMessages size
				ifTrue: [ chat addMessage: aMessage ]
				ifFalse: [ (nonToolMessages at: anIndex) merge: aMessage ] ]
%

! Class implementation for 'GtOpenAIResponseProvider'

!		Class methods for 'GtOpenAIResponseProvider'

category: 'as yet unclassified'
classmethod: GtOpenAIResponseProvider
providerName
	^ 'OpenAI Responses'
%

!		Instance methods for 'GtOpenAIResponseProvider'

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
addTool: aTool
	(tools anySatisfy: [ :tool | tool name = aTool name ])
		ifTrue: [ self error: 'Cannot add a tool of the same name multiple times.' ].

	tools add: aTool
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
beNotStreaming
	isStreaming := false
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
beStreaming
	isStreaming := true
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
defaultTools
	^ GtLlmToolsGroup new
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
executions
	^ executions
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
format: anObject
	super format: anObject.
	
	self beNotStreaming
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
gtExecutionsFor: aView
	<gtView>
	^ aView list
		title: 'Executions';
		items: [ executions ];
		priority: 10
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
gtToolsFor: aView
	<gtView>
	^ aView forward
		title: 'Tools';
		priority: 5;
		object: [ tools ];
		view: #gtItemsFor:
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
handleToolCall: aToolCall
	| toolOutput |
	chat removeLastMessage.
	chat
		addMessage: (GtOpenAIRawToolMessage new
				toolCall: aToolCall;
				rawData: aToolCall rawData).
	toolOutput := tools performToolCall: aToolCall.
	chat
		addMessage: (GtLlmToolMessage new
				toolCall: aToolCall;
				output: toolOutput).

	self chat signalRunHasUpdated.

	^ self executeWait
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
initialize
	super initialize.

	tools := self defaultTools.
	
	executions := OrderedCollection new.
	isStreaming := true
%

category: 'accessing'
method: GtOpenAIResponseProvider
instructions
	^ instructions
%

category: 'accessing'
method: GtOpenAIResponseProvider
instructions: anObject
	instructions := anObject
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
isStreaming: aBoolean
	isStreaming := aBoolean
%

category: 'accessing'
method: GtOpenAIResponseProvider
performToolCallsIn: result
	| toolOutputs |
	toolOutputs := result toolCalls
			collect: [ :aToolCall | 
				| toolOutput |
				chat
					addMessage: (GtOpenAIRawToolMessage new
							rawData: aToolCall responseInput).
				toolOutput := tools performToolCall: aToolCall.
				chat
					addMessage: (GtLlmToolMessage new
							toolCall: aToolCall;
							output: toolOutput) ].

	self chat signalRunHasUpdated.

	^ self executeWait
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
sendFiles: aListOfFileReferences withMessage: aString
	self
		sendAssistantMessage: (self userMessageClass new
				content: {{'type' -> 'input_text'.
							'text' -> aString} asDictionary}
						, (aListOfFileReferences
								collect: [ :aFileReference | 
									{'type' -> 'input_image'.
										'image_url'
											-> ('data:image/jpeg;base64,' , aFileReference binaryContents base64Encoded)}
										asDictionary ]);
				role: 'user';
				chat: self)
%

category: 'accessing'
method: GtOpenAIResponseProvider
tools
	^ tools
%

category: 'accessing'
method: GtOpenAIResponseProvider
tools: anObject
	tools := anObject
%

category: 'as yet unclassified'
method: GtOpenAIResponseProvider
triggerAssistant
	self chat signalRunHasStarted.
	assistantWorking := true.

	self executeWait
%

! Class implementation for 'GtLlmProvisionalThreadMessage'

!		Instance methods for 'GtLlmProvisionalThreadMessage'

category: 'accessing'
method: GtLlmProvisionalThreadMessage
action
	^ nil
%

category: 'as yet unclassified'
method: GtLlmProvisionalThreadMessage
ancestor
	^ self chat messages first
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
annotations
	^ #()
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
arguments
	^ {}
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
chat
	^ chat
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
chat: anObject
	chat := anObject
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
contentSummary
	^ ''
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
contentText
	^ ''
%

category: 'testing'
method: GtLlmProvisionalThreadMessage
createdAt
	<return: #DateAndTime>
	^ createdAt
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
createdAt: anObject
	createdAt := anObject
%

category: 'testing'
method: GtLlmProvisionalThreadMessage
hasResponse
	^ false
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
hasStep
	^ false
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
id
	^ 'c0801abb-21ce-0d00-a535-33e802e477be'
%

category: 'testing'
method: GtLlmProvisionalThreadMessage
isAssistantRole
	^ true
%

category: 'testing'
method: GtLlmProvisionalThreadMessage
isFailure
	^ false
%

category: 'as yet unclassified'
method: GtLlmProvisionalThreadMessage
senderText
	^ 'Assistant'
%

category: 'accessing'
method: GtLlmProvisionalThreadMessage
styler
	^ nil
%

category: 'subscriptions'
method: GtLlmProvisionalThreadMessage
unsubscribe: anObject
	"do nothing"

	
%

category: 'subscriptions'
method: GtLlmProvisionalThreadMessage
when: anEventSelector send: aMessageSelector to: anObject
	"do nothing"

	
%

! Class implementation for 'GtLlmRequestResponse'

!		Instance methods for 'GtLlmRequestResponse'

category: 'as yet unclassified'
method: GtLlmRequestResponse
gtRequestFor: aView
	<gtView>
	^ aView forward
		title: 'Request';
		priority: 1;
		object: [ request ];
		view: #gtJsonFor:
%

category: 'as yet unclassified'
method: GtLlmRequestResponse
gtResponseFor: aView
	<gtView>
	^ aView forward
		title: 'Response';
		priority: 2;
		object: [ response ];
		view: #gtJsonFor:
%

category: 'accessing'
method: GtLlmRequestResponse
request
	^ request
%

category: 'accessing'
method: GtLlmRequestResponse
request: anObject
	request := anObject
%

category: 'accessing'
method: GtLlmRequestResponse
response
	^ response
%

category: 'accessing'
method: GtLlmRequestResponse
response: anObject
	response := anObject
%

! Class implementation for 'GtLlmToolExamples'

!		Instance methods for 'GtLlmToolExamples'

category: 'as yet unclassified'
method: GtLlmToolExamples
calledTool
	<gtExample>
	| tool call |
	tool := self functionTool.
	call := self toolCall.


	self
		assert: (tool performToolCall: call)
		equals: call.

	^ tool
%

category: 'as yet unclassified'
method: GtLlmToolExamples
functionTool
	<gtExample>
	| tool |
	tool := self simpleFunctionTool
			name: 'example';
			description: 'Takes two arguments and passes them back unharmed.';
			parameters: {'first'.
					'second'};
			block: [:functionCall | functionCall ].

	^ tool
%

category: 'as yet unclassified'
method: GtLlmToolExamples
simpleFileSearchTool
	<gtExample>
	^ GtLlmFileSearchTool new
%

category: 'as yet unclassified'
method: GtLlmToolExamples
simpleFunctionTool
	<gtExample>
	| tool |
	tool := GtLlmFunctionTool new.
	
	self assert: tool type equals: 'function'.
	
	^ tool
%

category: 'as yet unclassified'
method: GtLlmToolExamples
simpleTool
	<gtExample>
	^ GtLlmTool new
%

category: 'as yet unclassified'
method: GtLlmToolExamples
simpleToolCall
	<gtExample>
	^ GtLlmFunctionToolCall new
%

category: 'as yet unclassified'
method: GtLlmToolExamples
toolCall
	<gtExample>
	| call |
	call := self simpleToolCall
			function: {'name' -> 'example'.
					'arguments' -> '{"first": 1, "second": 2}'} asDictionary.

	self assert: call name equals: 'example'.
	self
		assert: call arguments
		equals: {'first' -> 1.
				'second' -> 2} asDictionary.

	^ call
%

! Class implementation for 'GtLlmValueHolder'

!		Instance methods for 'GtLlmValueHolder'

category: 'announcer'
method: GtLlmValueHolder
announce: anAnnouncement
	^ self announcer announce: anAnnouncement
%

category: 'announcer'
method: GtLlmValueHolder
announcer
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
%

category: 'accessing'
method: GtLlmValueHolder
content
	^ content
%

category: 'accessing'
method: GtLlmValueHolder
content: anObject
	content := anObject
%

category: 'as yet unclassified'
method: GtLlmValueHolder
contentValue
	^ self content
%

category: 'announcer'
method: GtLlmValueHolder
hasSubscriber: anObject
	^ self announcer hasSubscriber: anObject
%

category: 'accessing'
method: GtLlmValueHolder
name
	^ name
%

category: 'accessing'
method: GtLlmValueHolder
name: anObject
	name := anObject
%

category: 'announcer - subscription'
method: GtLlmValueHolder
removeSubscription: subscription
	"Remove the given subscription from the receiver"
	^ self announcer removeSubscription: subscription
%

category: 'as yet unclassified'
method: GtLlmValueHolder
serialize
	^ name -> self contentValue
%

category: 'announcer - subscription'
method: GtLlmValueHolder
subscribe: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@statements2' 
						-> '`@receiver when: `@statements1 do: `@statements2'.

	^ self when: anAnnouncementClass do: aValuable
%

category: 'announcer - subscription'
method: GtLlmValueHolder
subscribe: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed."
	
	self
		deprecated: 'Please use #when:do:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 do: `@aValuable for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 do: `@aValuable for: `@aSubscriber'.
	
	^ self when: anAnnouncementClass do: aValuable for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmValueHolder
subscribe: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject'.
	^ self when: anAnnouncementClass do: (MessageSend receiver: anObject selector: aSelector)
%

category: 'announcer - subscription'
method: GtLlmValueHolder
subscribe: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."
	self
		deprecated: 'Please use #when:send:to:for: instead'
		transformWith: '`@receiver subscribe: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber' 
						-> '`@receiver when: `@statements1 send: `@statements2 to: `@anObject for: `@aSubscriber'.

	^ self when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmValueHolder
unsubscribe: anObject
	"Unsubscribe all subscriptions of anObject from the receiver"
	^ self announcer unsubscribe: anObject
%

category: 'as yet unclassified'
method: GtLlmValueHolder
updateContent: aValue
	content := aValue
%

category: 'as yet unclassified'
method: GtLlmValueHolder
value
	^ self content
%

category: 'announcer - subscription'
method: GtLlmValueHolder
weak
	"announcer weak subscribe: foo"
	^ self announcer weak
%

category: 'announcer - subscription'
method: GtLlmValueHolder
when: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that suach a method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
		^ self announcer when: anAnnouncementClass do: aValuable
%

category: 'announcer - subscription'
method: GtLlmValueHolder
when: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."

	^ self announcer when: anAnnouncementClass do: aValuable for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmValueHolder
when: anAnnouncementClass doOnce: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber.
	A valuable is executed ONCE, and then a subscriber gets unsubscribed"
	^ self
		when: anAnnouncementClass
		do: [ :anAnnouncement |
			self unsubscribe: aSubscriber.
			aValuable cull: anAnnouncement ]
		for: aSubscriber
%

category: 'announcer - subscription'
method: GtLlmValueHolder
when: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"
		^ self announcer when: anAnnouncementClass send: aSelector to: anObject
%

category: 'announcer - subscription'
method: GtLlmValueHolder
when: anAnnouncementClass send: aSelector to: anObject for: aSubscriber
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^ (self when: anAnnouncementClass send: aSelector to: anObject) subscriber: aSubscriber
%

! Class implementation for 'GtLlmSerializableValueHolder'

!		Instance methods for 'GtLlmSerializableValueHolder'

category: 'as yet unclassified'
method: GtLlmSerializableValueHolder
contentValue
	^ self serializer value: self content
%

category: 'as yet unclassified'
method: GtLlmSerializableValueHolder
initialize
	super initialize.

	updater := [ :_ :aValue | self content: aValue ].
	serializer := #yourself
%

category: 'accessing'
method: GtLlmSerializableValueHolder
serializer
	^ serializer
%

category: 'accessing'
method: GtLlmSerializableValueHolder
serializer: anObject
	serializer := anObject
%

category: 'as yet unclassified'
method: GtLlmSerializableValueHolder
updateContent: aValue
	self updater cull: content cull: aValue
%

category: 'accessing'
method: GtLlmSerializableValueHolder
updater
	^ updater
%

category: 'accessing'
method: GtLlmSerializableValueHolder
updater: anObject
	updater := anObject
%

! Class implementation for 'GtLlmCustomSerializationValueHolder'

!		Instance methods for 'GtLlmCustomSerializationValueHolder'

category: 'as yet unclassified'
method: GtLlmCustomSerializationValueHolder
serialize
	^ self contentValue
%

! Class implementation for 'GtLlmValueSerializer'

!		Instance methods for 'GtLlmValueSerializer'

category: 'serialization'
method: GtLlmValueSerializer
serializeBinding: aBinding withValue: aBindingValue
	^ {'name' -> aBinding name.
		'bindingClass' -> aBinding class name asString.
		'value'
			-> (self serializeValue: aBindingValue)}
		asDictionary
%

category: 'serialization'
method: GtLlmValueSerializer
serializeClass: aClass
	^ {'class' -> aClass name.
		'superclass'
			-> (aClass superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		'comment' -> aClass instanceSide gtComment.
		'package' -> aClass package name.
		'instanceSlots' -> aClass slotNames.
		'allInstanceMethods' -> (aClass methods asArray collect: [ :aMethod | aMethod selector ])} asDictionary
%

category: 'serialization'
method: GtLlmValueSerializer
serializeValue: aValue
	^ {'class' -> aValue class name asString.
		'superclass'
			-> (aValue class superclass ifNil: [ nil ] ifNotNil: [ :aSuperclass | aSuperclass name ]).
		'comment' -> aValue class instanceSide gtComment.
		'package' -> aValue class package name.
		'printString' -> (aValue printString escapeCharacter: '''').
		'allInstanceMethods'
			-> (aValue
					ifNil: [ {} ]
					ifNotNil: [ aValue class methods asArray collect: [ :aMethod | aMethod selector ] ]).
		'instanceSlots'
			-> (aValue class allSlots
					collect: [ :aSlot | 
						| slotValue |
						slotValue := aValue readSlotNamed: aSlot name.
						{'name' -> aSlot name.
							'class' -> slotValue class asString.
							'value' -> (slotValue asString escapeCharacter: '''')} asDictionary ])
					asArray} asDictionary
%

! Class implementation for 'GtMcpClient'

!		Instance methods for 'GtMcpClient'

category: 'accessing'
method: GtMcpClient
callTool: aString withArguments: anObject
	^ (self
		sendMethod: 'tools/call'
		withParams: {'name' -> aString.
				'arguments' -> anObject} asDictionary) at: 'result' at: 'content'
%

category: 'accessing'
method: GtMcpClient
getPrompt: aString withArguments: anObject
	^ (self
		sendMethod: 'prompts/get'
		withParams: {'name' -> aString.
				'arguments' -> anObject} asDictionary) at: 'result'
%

category: 'as yet unclassified'
method: GtMcpClient
gtCapabilitiesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Capabilities';
		priority: 1;
		items: [ serverCapabilities associations ];
		column: 'Capability' text: [ :aCapability | aCapability key ];
		column: 'Information' text: [ :aCapability | aCapability value ]
%

category: 'as yet unclassified'
method: GtMcpClient
gtPromptsFor: aView
	<gtView>
	(serverCapabilities includesKey: 'prompts') ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Prompts';
		priority: 2;
		items: [ self listPrompts ];
		column: 'Name' text: [ :aTool | aTool at: 'name' ];
		column: 'Description'
			text: [ :aTool | aTool at: 'description' ]
			weight: 3;
		column: 'Arguments'
			text: [ :aTool | 
				', '
					join: ((aTool at: 'arguments') collect: [ :anArgument | anArgument at: 'name' ]) ]
%

category: 'as yet unclassified'
method: GtMcpClient
gtResourcesFor: aView
	<gtView>
	(serverCapabilities includesKey: 'resources') ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Resources';
		priority: 2;
		items: [ self listResources ];
		column: 'Name' text: [ :aTool | aTool at: 'name' ];
		column: 'URI' text: [ :aTool | aTool at: 'uri' ] weight: 2;
		column: 'Description'
			text: [ :aTool | aTool at: 'description' ifAbsent: [ '' ] ]
			weight: 3
%

category: 'as yet unclassified'
method: GtMcpClient
gtToolsFor: aView
	<gtView>
	(serverCapabilities includesKey: 'tools') ifFalse: [ ^ aView empty ].

	^ aView columnedList
		title: 'Tools';
		priority: 2;
		items: [ self listTools ];
		column: 'Name' text: [:aTool | aTool at: 'name' ];
		column: 'Description' text: [:aTool | aTool at: 'description' ] weight: 3
%

category: 'as yet unclassified'
method: GtMcpClient
initialize
	super initialize.
	
	messageId := 0.
	serverCapabilities := {} asDictionary
%

category: 'as yet unclassified'
method: GtMcpClient
initializeSession
	| response |
	response := self
			sendMethod: 'initialize'
			withParams: {'protocolVersion' -> '2024-11-05'.
					'capabilities'
						-> {'roots' -> {} asDictionary.
								'sampling' -> {} asDictionary.
								'elicitation' -> {} asDictionary} asDictionary.
					'clientInfo'
						-> {'name' -> 'Glamorous Toolkit'.
								'title' -> 'Glamorous Toolkit LLM Integration'.
								'version' -> '1.0.0'} asDictionary} asDictionary.

	serverCapabilities := response at: 'result' at: 'capabilities'.

	transport
		sendMessage: {'jsonrpc' -> '2.0'. 'method' -> 'notifications/initialized'} asDictionary
%

category: 'as yet unclassified'
method: GtMcpClient
listPrompts
	^ (self sendMethod: 'prompts/list' withParams: {} asDictionary)
		at: 'result'
		at: 'prompts'
%

category: 'as yet unclassified'
method: GtMcpClient
listResources
	^ (self sendMethod: 'resources/list' withParams: {} asDictionary)
		at: 'result'
		at: 'resources'
%

category: 'as yet unclassified'
method: GtMcpClient
listTools
	^ (self sendMethod: 'tools/list' withParams: {} asDictionary)
		at: 'result'
		at: 'tools'
%

category: 'accessing'
method: GtMcpClient
llmFunctionTools
	^ self listTools
		collect: [ :aTool | 
			GtLlmFunctionTool new
				name: (aTool at: 'name');
				parameters: (aTool at: 'inputSchema' at: 'properties') keys;
				description: (aTool at: 'description');
				block: [ :functionCall | 
					STONJSON
						toString: (self callTool: (aTool at: 'name') withArguments: functionCall arguments) ] ]
%

category: 'as yet unclassified'
method: GtMcpClient
messagesFromPrompt: aPromptName withArguments: anArgsDictionary
	^ ((self getPrompt: aPromptName withArguments: anArgsDictionary) at: 'messages')
		collect: [ :aMessage | 
			GtLlmChatMessage new
				role: (aMessage at: 'role');
				content: (aMessage at: 'content' at: 'text') ]
%

category: 'as yet unclassified'
method: GtMcpClient
nextMessageId
	messageId := messageId + 1.
	^ messageId
%

category: 'as yet unclassified'
method: GtMcpClient
readResource: aString
	^ (self
		sendMethod: 'resources/read'
		withParams: {'uri' -> aString} asDictionary) at: 'result' at: 'contents'
%

category: 'as yet unclassified'
method: GtMcpClient
sendMethod: aString withParams: anObject
	| content |
	content := {'jsonrpc' -> '2.0'.
					'id' -> self nextMessageId.
					'method' -> aString.
					'params' -> anObject} asDictionary.
	transport sendMessage: content.
	^ transport receiveResponse
%

category: 'accessing'
method: GtMcpClient
transport
	^ transport
%

category: 'accessing'
method: GtMcpClient
transport: anObject
	transport ifNotNil: [ transport terminate ].

	transport := anObject.

	self initializeSession
%

! Class implementation for 'GtMcpClientExamples'

!		Instance methods for 'GtMcpClientExamples'

category: 'as yet unclassified'
method: GtMcpClientExamples
clientListPrompts
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'prompts' -> {}} asDictionary} asDictionary.

	self assert: client listPrompts size equals: 0.

	^ client
%

category: 'as yet unclassified'
method: GtMcpClientExamples
clientListResources
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'resources' -> {}} asDictionary} asDictionary.

	self assert: client listResources size equals: 0.

	^ client
%

category: 'as yet unclassified'
method: GtMcpClientExamples
clientListTools
	<gtExample>
	| client |
	client := self simpleClientWithTransport.
	client transport
		addMessage: {'result' -> {'tools' -> {}} asDictionary} asDictionary.

	self assert: client listTools size equals: 0.

	^ client
%

category: 'as yet unclassified'
method: GtMcpClientExamples
simpleClient
	<gtExample>
	^ GtMcpClient new
%

category: 'as yet unclassified'
method: GtMcpClientExamples
simpleClientWithTransport
	<gtExample>
	^ GtMcpClient new
		transport: (GtMcpStaticTransport new
				messages: {{'result'
								-> {'capabilities'
											-> {'tools' -> {} asDictionary.
													'prompts' -> {} asDictionary.
													'resources' -> {} asDictionary} asDictionary} asDictionary}
							asDictionary}asOrderedCollection)
%

! Class implementation for 'GtMcpPrompt'

!		Instance methods for 'GtMcpPrompt'

category: 'accessing'
method: GtMcpPrompt
arguments
	^ arguments
%

category: 'accessing'
method: GtMcpPrompt
arguments: anObject
	arguments := anObject
%

category: 'as yet unclassified'
method: GtMcpPrompt
callWith: args
	^ promptBlock value: args
%

category: 'accessing'
method: GtMcpPrompt
description
	^ description
%

category: 'accessing'
method: GtMcpPrompt
description: anObject
	description := anObject
%

category: 'accessing'
method: GtMcpPrompt
name
	^ name
%

category: 'accessing'
method: GtMcpPrompt
name: anObject
	name := anObject
%

category: 'accessing'
method: GtMcpPrompt
promptBlock
	^ promptBlock
%

category: 'accessing'
method: GtMcpPrompt
promptBlock: anObject
	promptBlock := anObject
%

! Class implementation for 'GtMcpResource'

!		Instance methods for 'GtMcpResource'

category: 'as yet unclassified'
method: GtMcpResource
contents
	^ contentsBlock value
%

category: 'accessing'
method: GtMcpResource
contentsBlock
	^ contentsBlock
%

category: 'accessing'
method: GtMcpResource
contentsBlock: anObject
	contentsBlock := anObject
%

category: 'accessing'
method: GtMcpResource
description
	^ description ifNil: [ name ]
%

category: 'accessing'
method: GtMcpResource
description: anObject
	description := anObject
%

category: 'accessing'
method: GtMcpResource
mimeType
	^ mimeType
%

category: 'accessing'
method: GtMcpResource
mimeType: anObject
	mimeType := anObject
%

category: 'accessing'
method: GtMcpResource
name
	^ name
%

category: 'accessing'
method: GtMcpResource
name: anObject
	name := anObject
%

category: 'accessing'
method: GtMcpResource
title
	^ title ifNil: [ name ]
%

category: 'accessing'
method: GtMcpResource
title: anObject
	title := anObject
%

category: 'accessing'
method: GtMcpResource
uri
	^ uri
%

category: 'accessing'
method: GtMcpResource
uri: anObject
	uri := anObject
%

! Class implementation for 'GtMcpStaticTransport'

!		Instance methods for 'GtMcpStaticTransport'

category: 'as yet unclassified'
method: GtMcpStaticTransport
addMessage: aMessage
	messages add: aMessage
%

category: 'as yet unclassified'
method: GtMcpStaticTransport
initialize
	super initialize.
	
	index := 0.
	messages := OrderedCollection new
%

category: 'accessing'
method: GtMcpStaticTransport
messages
	^ messages
%

category: 'accessing'
method: GtMcpStaticTransport
messages: anObject
	messages := anObject
%

category: 'as yet unclassified'
method: GtMcpStaticTransport
receiveResponse
	index := index + 1.
	^ messages at: index ifAbsent: [ {} asDictionary ]
%

category: 'as yet unclassified'
method: GtMcpStaticTransport
sendMessage: aDict
%

! Class implementation for 'GtMcpStdioTransport'

!		Instance methods for 'GtMcpStdioTransport'

category: 'as yet unclassified'
method: GtMcpStdioTransport
gtMessagesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ messages ];
		column: 'Method'
			text: [ :aMessage | aMessage at: 'method' ifAbsent: [ 'response' ] ];
		column: 'Body'
			text: [ :aMessage | aMessage ]
			weight: 3
%

category: 'as yet unclassified'
method: GtMcpStdioTransport
initialize
	super initialize.
	
	messages := OrderedCollection new
%

category: 'accessing'
method: GtMcpStdioTransport
process
	^ process
%

category: 'accessing'
method: GtMcpStdioTransport
process: anObject
	process := anObject.
	
	stdout := process asynchronousStdout
%

category: 'accessing'
method: GtMcpStdioTransport
receiveResponse
	| resultString ston value result |
	resultString := ''.
	[ resultString := resultString , stdout pollString.
	[ ston := STON reader on: resultString readStream.
	value := ston next.
	ston atEnd ] on: STONReaderError do: [ false ] ] whileFalse.
	result := STONJSON fromString: resultString.
	
	messages add: result.

	(result includesKey: 'error')
		ifTrue: [ self error: (result at: 'error') asString ].


	((result includesKey: 'method')
		and: [ (result at: 'method') = 'notifications/message' ])
		ifTrue: [ ^ self receiveResponse ].

	^ result
%

category: 'as yet unclassified'
method: GtMcpStdioTransport
sendMessage: anObject
	messages add: anObject.
	process stdin
		nextPutAll: (STONJSON toString: anObject);
		crlf
%

category: 'as yet unclassified'
method: GtMcpStdioTransport
terminate
	process kill
%

! Class implementation for 'GtOllamaClient'

!		Class methods for 'GtOllamaClient'

category: 'accessing'
classmethod: GtOllamaClient
defaultBaseUrl
	^ 'http://localhost:11434/api' asZnUrl
%

!		Instance methods for 'GtOllamaClient'

category: 'accessing'
method: GtOllamaClient
baseUrl
	^ baseUrl
%

category: 'accessing'
method: GtOllamaClient
baseUrl: anObject
	baseUrl := anObject
%

category: 'accessing'
method: GtOllamaClient
checkForErrors: aResponse
	(aResponse isDictionary and: [aResponse includesKey: 'error'])
		ifTrue: [ ^ (GtOllamaError from: (aResponse at: 'error')) signal ].

	^ aResponse
%

category: 'accessing'
method: GtOllamaClient
completeChatWithModel: aString andMessages: aCollection
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
%

category: 'accessing'
method: GtOllamaClient
completeChatWithModel: aString andMessages: aCollection andFormat: aFormat
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		perform
%

category: 'accessing'
method: GtOllamaClient
completeChatWithModel: aString andMessages: aCollection andFormat: aFormat andTools: tools
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: tools;
		perform
%

category: 'accessing'
method: GtOllamaClient
completeChatWithModel: aString andMessages: aCollection andFormat: aFormat andTools: tools andInstructions: instructions
	^ GtOllamaCompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		format: aFormat;
		tools: tools;
		instructions: instructions;
		perform
%

category: 'accessing'
method: GtOllamaClient
createModel: aString withModelFile: aModelFile
	^ GtOllamaCreateModelClient new
		client: self;
		model: aString;
		modelFile: aModelFile;
		perform
%

category: 'accessing'
method: GtOllamaClient
defaultBaseUrl
	^ self class defaultBaseUrl
%

category: 'accessing'
method: GtOllamaClient
deleteModel: aString
	^ GtOllamaDeleteModelClient new
		client: self;
		model: aString;
		perform
%

category: 'accessing'
method: GtOllamaClient
generateEmbeddingFor: aString 
		^ GtOllamaGenerateEmbeddingsAPIClient new
		client: self;
		input: aString;
		perform
%

category: 'accessing'
method: GtOllamaClient
generateEmbeddingsWithModel: aModelString andInput: anInputString
	^ GtOllamaGenerateEmbeddingsAPIClient new
		client: self;
		input: anInputString;
		model: aModelString;
		perform
%

category: 'accessing'
method: GtOllamaClient
generateResponseWithModel: modelString andPrompt: promptString

	^ GtOllamaGenerateResponseClient new
		client: self;
		model: modelString;
		prompt: promptString;
		perform
%

category: 'accessing'
method: GtOllamaClient
generateResponseWithModel: modelString prompt: promptString andImages: anArrayOfStrings
	^ GtOllamaGenerateResponseClient new
		client: self;
		model: modelString;
		prompt: promptString;
		images: anArrayOfStrings;
		perform
%

category: 'accessing'
method: GtOllamaClient
get: aString
	| aClient response |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.


	response := aClient get.
	
	history add: (aClient request -> aClient response).
	
	^ response
%

category: 'accessing'
method: GtOllamaClient
getModelInformationFor: aName
	^ GtOllamaGetModelInformationAPIClient new
		client: self;
		model: aName;
		perform
%

category: 'as yet unclassified'
method: GtOllamaClient
gtCallsFor: aView
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 5;
		object: [ history ];
		view: #gtCallsFor:
%

category: 'accessing'
method: GtOllamaClient
gtModelsFor: aView
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtModelsFor:
%

category: 'accessing'
method: GtOllamaClient
gtRunningModelsFor: aView
	<gtView>
	^ aView forward
		title: 'Running models';
		priority: 2;
		object: [self listRunningModels];
		view: #gtModelsFor:
%

category: 'accessing'
method: GtOllamaClient
initialize
	super initialize.
	
	self baseUrl: self defaultBaseUrl.
	
	history := GtLlmRequestHistory new
%

category: 'accessing'
method: GtOllamaClient
listModels
	^ GtOllamaListModelsClient new
		client: self;
		perform
%

category: 'accessing'
method: GtOllamaClient
listRunningModels
	^ GtOllamaListRunningModelsClient new
		client: self;
		perform
%

category: 'accessing'
method: GtOllamaClient
post: aString withEntity: anEntity
	| aClient response |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	response := aClient post.
	
	history add: (aClient request -> aClient response).
	
	^ response
%

category: 'accessing'
method: GtOllamaClient
pullModel: aString 
	^ GtOllamaPullModelClient new
		client: self;
		model: aString;
		perform
%

category: 'as yet unclassified'
method: GtOllamaClient
pushModel: aString 
	^ GtOllamaPushModelClient new
		client: self;
		model: aString;
		perform
%

! Class implementation for 'GtOpenAIClient'

!		Class methods for 'GtOpenAIClient'

category: 'accessing'
classmethod: GtOpenAIClient
apiKeyFile
	^ ApiKeyFile
%

category: 'accessing'
classmethod: GtOpenAIClient
apiKeyFile: aFile
	ApiKeyFile := aFile
%

category: 'accessing'
classmethod: GtOpenAIClient
apiKeyFileContents
	^ ApiKeyFile contents trimBoth
%

category: 'accessing'
classmethod: GtOpenAIClient
defaultApiKeyFile
	<gtExample>
	^ FileLocator home / '.secrets' / 'open-ai-api-key.txt'
%

category: 'accessing'
classmethod: GtOpenAIClient
initialize
	ApiKeyFile := self defaultApiKeyFile
%

category: 'accessing'
classmethod: GtOpenAIClient
new
	^ self basicNew initialize
%

category: 'accessing'
classmethod: GtOpenAIClient
withApiKeyFromFile
	^ self new apiKey: self apiKeyFileContents
%

!		Instance methods for 'GtOpenAIClient'

category: 'accessing'
method: GtOpenAIClient
addMessage: aMessage toThread: aThreadId
	^ GtOpenAIAddMessageToThreadAPIClient new
		client: self;
		message: aMessage;
		thread: aThreadId;
		perform
%

category: 'as yet unclassified'
method: GtOpenAIClient
apiKey
	^ apiKey
%

category: 'accessing'
method: GtOpenAIClient
apiKey: anApiKey
	apiKey := anApiKey
%

category: 'accessing'
method: GtOpenAIClient
baseUrl
	^ baseUrl
%

category: 'accessing'
method: GtOpenAIClient
baseUrl: anObject
	baseUrl := anObject asZnUrl
%

category: 'accessing'
method: GtOpenAIClient
checkForErrors: aResponse
	((aResponse includesKey: 'error')
		and: [ ((aResponse at: 'error') isKindOf: Collection)
				and: [ (aResponse at: 'error') includesKey: 'message' ] ])
		ifTrue: [ ^ (GtOpenAIError from: (aResponse at: 'error')) signal ].

	^ aResponse
%

category: 'as yet unclassified'
method: GtOpenAIClient
completeChatWithModel: aString andMessages: aCollection
	^ GtOpenAICompleteChatAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform
%

category: 'accessing'
method: GtOpenAIClient
createAssistant: anAssistant 
	^ GtOpenAICreateAssistantAPIClient new
		client: self;
		assistant: anAssistant;
		perform
%

category: 'accessing'
method: GtOpenAIClient
createFineTuningJobOnModel: aModelName withFile: aFileId
	^ GtOpenAICreateFineTuningJobAPIClient new
		client: self;
		model: aModelName;
		file: aFileId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
createRunForThread: aThreadId usingAssistant: anAssistantId
	^ GtOpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
createRunForThread: aThreadId usingAssistant: anAssistantId andResponseFormat: aFormat
	^ GtOpenAICreateThreadRunAPIClient new
		client: self;
		assistant: anAssistantId;
		thread: aThreadId;
		responseFormat: aFormat;
		perform
%

category: 'accessing'
method: GtOpenAIClient
createThreadWithMessages: aListOfMessages 
	^ GtOpenAICreateThreadAPIClient new
		client: self;
		messages: aListOfMessages;
		perform
%

category: 'accessing'
method: GtOpenAIClient
createVectorStoreNamed: aName withFiles: aCollectionOfFileIds
	^ GtOpenAICreateVectorStoreAPIClient new
		client: self;
		name: aName;
		files: aCollectionOfFileIds;
		perform
%

category: 'default'
method: GtOpenAIClient
defaultBaseUrl
	^ 'https://api.openai.com/v1' asZnUrl
%

category: 'accessing'
method: GtOpenAIClient
delete: aUrl
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	
	aClient entity: nil.

	response := aClient delete.
	
	history add: (aClient request -> aClient response).
	
	^ response
%

category: 'accessing'
method: GtOpenAIClient
deleteAssistant: anAssistantId
	^ GtOpenAIDeleteAssistantAPIClient new
		client: self;
		assistant: anAssistantId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
deleteFile: aFileId
	^ GtOpenAIDeleteFileAPIClient new
		client: self;
		file: aFileId;
		perform
%

category: 'as yet unclassified'
method: GtOpenAIClient
deleteModel: aModel 
	^ GtOpenAIDeleteModelAPIClient new
		client: self;
		model: aModel;
		perform
%

category: 'accessing'
method: GtOpenAIClient
deleteVectorStore: anId
	^ GtOpenAIDeleteVectorStoreAPIClient new
		client: self;
		vectorStore: anId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
generateEmbeddingsWithModel: aString andInput: anInputString
	^ GtOpenAIGenerateEmbeddingAPIClient new
		client: self;
		model: aString;
		input: anInputString;
		perform
%

category: 'as yet unclassified'
method: GtOpenAIClient
generateResponseWithModel: aString andMessages: aCollection
	^ GtOpenAIGenerateResponseAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		perform 
%

category: 'as yet unclassified'
method: GtOpenAIClient
generateResponseWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat
	^ GtOpenAIGenerateResponseAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		tools: aCollectionOfTools;
		format: aFormat;
		perform 
%

category: 'as yet unclassified'
method: GtOpenAIClient
generateResponseWithModel: aString messages: aCollection instructions: anInstruction tools: aCollectionOfTools andFormat: aFormat isStreaming: aBoolean
	^ GtOpenAIGenerateResponseAPIClient new
		client: self;
		model: aString;
		messages: aCollection;
		instructions: anInstruction;
		tools: aCollectionOfTools;
		format: aFormat;
		isStreaming: aBoolean;
		perform 
%

category: 'accessing'
method: GtOpenAIClient
get: aUrl
	^ self get: aUrl withParams: {}
%

category: 'accessing'
method: GtOpenAIClient
get: aUrl withParams: aListOfAssocs
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aUrl.
	aListOfAssocs do: [ :aPair | aClient queryAt: aPair key put: aPair value ].

	aClient entity: nil.

	response := aClient get.
	
	history add: (aClient request -> aClient response).
	
	^ self checkForErrors: response
%

category: 'accessing'
method: GtOpenAIClient
getFile: aFileId
	^ GtOpenAIGetFileAPIClient new
		client: self;
		file: aFileId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
getFileContents: aFileId
	^ GtOpenAIGetFileContentsAPIClient new
		client: self;
		file: aFileId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
getFineTuningCheckpointsForJob: anId
	^ GtOpenAIGetFineTuningCheckpointsForJobAPIClient new
		client: self;
		job: anId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
getFineTuningEventsForJob: anId
	^ GtOpenAIGetFineTuningEventsForJobAPIClient new
		client: self;
		job: anId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
getFineTuningJob: anId
	^ GtOpenAIGetFineTuningJobAPIClient new
		client: self;
		job: anId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
getRun: aRunId forThread: aThreadId
	^ GtOpenAIGetThreadRunAPIClient new
		client: self;
		run: aRunId;
		thread: aThreadId;
		perform
%

category: 'as yet unclassified'
method: GtOpenAIClient
gtCallsFor: aView
	<gtView>
	^ aView forward
		title: 'Calls';
		priority: 5;
		object: [ history ];
		view: #gtCallsFor:
%

category: 'accessing'
method: GtOpenAIClient
gtModelsFor: aView
	<gtView>
	^ aView forward
		title: 'Models';
		priority: 1;
		object: [ self listModels ];
		view: #gtViewModelsFor:
%

category: 'accessing'
method: GtOpenAIClient
initialize
	super initialize.
	
	history := GtLlmRequestHistory new.

	self baseUrl: self defaultBaseUrl
%

category: 'accessing'
method: GtOpenAIClient
listAssistants
	^ GtOpenAIListAssistantsAPIClient new
		client: self;
		perform
%

category: 'accessing'
method: GtOpenAIClient
listFiles
	^ GtOpenAIListFilesAPIClient new
		client: self;
		perform
%

category: 'accessing'
method: GtOpenAIClient
listMessagesForThread: aThreadId 
	^ GtOpenAIListThreadMessagesAPIClient new
		client: self;
		thread: aThreadId;
		perform
%

category: 'accessing'
method: GtOpenAIClient
listModels
	^ GtOpenAIListModelsAPIClient new
		client: self;
		perform
%

category: 'accessing'
method: GtOpenAIClient
listVectorStores
	^ GtOpenAIListVectorStoresAPIClient new
		client: self;
		perform
%

category: 'accessing'
method: GtOpenAIClient
post: aString withEntity: anEntity
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.
	
	response := aClient post.
	
	history add: (aClient request -> aClient response).

	^ self checkForErrors: response
%

category: 'accessing'
method: GtOpenAIClient
postFile: aString withEntity: anEntity
	| aClient response |
	aClient := self initializeClient.
	aClient url: self baseUrl / aString.

	aClient entity: anEntity.
	
	response := aClient post.
	
	history add: (aClient request -> aClient response).

	^ self checkForErrors: response
%

category: 'as yet unclassified'
method: GtOpenAIClient
submitToolOutputs: output toThread: aThreadId anRun: aRunId 
	^ GtOpenAISubmitToolOutputsAPIClient new
		client: self;
		thread: aThreadId;
		run: aRunId;
		outputs: output;
		perform
%

category: 'accessing'
method: GtOpenAIClient
uploadFile: aFileReference withPurpose: aString 
	^ GtOpenAIUploadFileAPIClient new
		client: self;
		file: aFileReference;
		purpose: aString;
		perform
%

! Class implementation for 'GtOpenAIGroup'

!		Class methods for 'GtOpenAIGroup'

category: 'instance creation'
classmethod: GtOpenAIGroup
from: aList
	^ self
		withAll: ((aList at: 'data') collect: [ :aModel | self itemClass from: aModel ])
%

category: 'accessing'
classmethod: GtOpenAIGroup
itemClass
	^ self subclassResponsibility
%

category: 'as yet unclassified'
classmethod: GtOpenAIGroup
withAll: aCollection
	^ self new 
		initializeWith: aCollection
%

!		Instance methods for 'GtOpenAIGroup'

category: 'accessing'
method: GtOpenAIGroup
add: anItem
	self items add: anItem
%

category: 'accessing'
method: GtOpenAIGroup
addAll: aCollection
	self items addAll: aCollection
%

category: 'accessing'
method: GtOpenAIGroup
addFirst: anItem
	self items addFirst: anItem
%

category: 'accessing'
method: GtOpenAIGroup
addItem: anItem
	self items add: anItem
%

category: 'accessing'
method: GtOpenAIGroup
addItems: aCollection
	self items addAll: aCollection
%

category: 'accessing'
method: GtOpenAIGroup
allButFirst
	^ self species withAll: self items allButFirst
%

category: 'accessing'
method: GtOpenAIGroup
allButLast
	^ self species withAll: self items allButLast
%

category: 'accessing'
method: GtOpenAIGroup
anyOne
	^ self items anyOne
%

category: 'accessing'
method: GtOpenAIGroup
anySatisfy: aBlock
	^ self items anySatisfy: aBlock
%

category: 'accessing'
method: GtOpenAIGroup
asArray
	^ self items asArray
%

category: 'accessing'
method: GtOpenAIGroup
asBag
	^ self items asBag
%

category: 'accessing'
method: GtOpenAIGroup
asOrderedCollection
	^ self items asOrderedCollection
%

category: 'accessing'
method: GtOpenAIGroup
asSet
	^ self items asSet
%

category: 'accessing'
method: GtOpenAIGroup
asSortedCollection: aBlock
	^ self items asSortedCollection: aBlock
%

category: 'accessing'
method: GtOpenAIGroup
at: anIndex
	^ self items at: anIndex
%

category: 'accessing'
method: GtOpenAIGroup
client
	^ client
%

category: 'accessing'
method: GtOpenAIGroup
client: anObject
	client := anObject.

	self do: [ :anItem | anItem client: client ]
%

category: 'enumerating'
method: GtOpenAIGroup
collect: aBlock
	^ self items collect: aBlock
%

category: 'enumerating'
method: GtOpenAIGroup
collect: aBlock as: aClass
	^ self items 
		collect: aBlock as: aClass
%

category: 'enumerating'
method: GtOpenAIGroup
collect: collectBlock thenReject: selectBlock
	^ self items collect: collectBlock thenReject: selectBlock
%

category: 'enumerating'
method: GtOpenAIGroup
collect: collectBlock thenSelect: selectBlock
	^ self items collect: collectBlock thenSelect: selectBlock
%

category: 'enumerating'
method: GtOpenAIGroup
collectWithIndex: aBlock
	^ self items collectWithIndex: aBlock
%

category: 'enumerating'
method: GtOpenAIGroup
detect: aBlock 
	^ self items detect: aBlock 
%

category: 'enumerating'
method: GtOpenAIGroup
detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
	^ self items 
		detect: aBlock ifFound: foundBlock ifNone: exceptionBlock
%

category: 'enumerating'
method: GtOpenAIGroup
detect: aBlock ifNone: exceptionBlock
	^ self items 
		detect: aBlock ifNone: exceptionBlock
%

category: 'accessing'
method: GtOpenAIGroup
detectIndex: aBlock
	^ self items detectIndex: aBlock
%

category: 'accessing'
method: GtOpenAIGroup
detectIndex: aBlock ifNone: exceptionBlock
	^ self items detectIndex: aBlock ifNone: exceptionBlock
%

category: 'enumerating'
method: GtOpenAIGroup
detectMax: aBlock 
	^ self items detectMax: aBlock 
%

category: 'enumerating'
method: GtOpenAIGroup
detectMin: aBlock 
	^ self items detectMin: aBlock 
%

category: 'accessing'
method: GtOpenAIGroup
do: aBlock
	^ self items do: aBlock
%

category: 'compatibility - DeepTraverser'
method: GtOpenAIGroup
dtRawTraverseUsing: aStream
	self do: [ :each | aStream traverse: each ]
%

category: 'compatibility - DeepTraverser'
method: GtOpenAIGroup
dtTraverseStartUsing: aStream
	self do: [ :each | each dtTraverseStartUsing: aStream ]
%

category: 'compatibility - DeepTraverser'
method: GtOpenAIGroup
dtTraverseUsing: aStream
	self do: [ :each | each dtTraverseUsing: aStream ]
%

category: 'accessing'
method: GtOpenAIGroup
first
	^ self items first
%

category: 'accessing'
method: GtOpenAIGroup
first: aCount
	^ self species 
		withAll: (self items first: aCount)
%

category: 'accessing'
method: GtOpenAIGroup
flatCollect: aBlock
	^ self items flatCollect: aBlock
%

category: 'accessing'
method: GtOpenAIGroup
flatCollect: aBlock as: aClass
	^ self items flatCollect: aBlock as: aClass
%

category: 'accessing'
method: GtOpenAIGroup
groupedBy: aBlock 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	| result |
	result := Dictionary new.
	self do:[:each | 
		| key collection |
		key := aBlock value: each.
		collection := result at: key ifAbsentPut: [ OrderedCollection new].
		collection add: each].
		
	result keysAndValuesDo: [:key :value | 
		result at: key put: (self species withAll: value)].

	^result
%

category: 'accessing'
method: GtOpenAIGroup
groupedBy: aBlock having: conditionBlock 
	"Override this method here and not reuse the one in collection
	because we want the keys to be groups, not simple collections"
	
	^ (self groupedBy: aBlock) select: conditionBlock
%

category: 'testing'
method: GtOpenAIGroup
identityIncludes: anObject
	^ self items identityIncludes: anObject
%

category: 'testing'
method: GtOpenAIGroup
ifEmpty: aBlock
	^ self items ifEmpty: aBlock
%

category: 'testing'
method: GtOpenAIGroup
ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
	^ self items ifEmpty: emptyBlock ifNotEmpty: notEmptyBlock
%

category: 'testing'
method: GtOpenAIGroup
ifNotEmpty: aBlock
	^ self items ifNotEmpty: aBlock
%

category: 'testing'
method: GtOpenAIGroup
ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
	^ self items ifNotEmpty: notEmptyBlock ifEmpty: emptyBlock
%

category: 'testing'
method: GtOpenAIGroup
includes: anObject
	^ self items includes: anObject
%

category: 'accessing'
method: GtOpenAIGroup
indexOf: aBlock
	^ self items indexOf: aBlock
%

category: 'initialization'
method: GtOpenAIGroup
initializeWith: aCollection
	items := aCollection
%

category: 'accessing'
method: GtOpenAIGroup
inject: anObject into: aBlock
	^ self items inject: anObject into: aBlock
%

category: 'accessing'
method: GtOpenAIGroup
isCollection
	^ true
%

category: 'testing'
method: GtOpenAIGroup
isEmpty

	^ self items isEmpty
%

category: 'testing'
method: GtOpenAIGroup
isEmptyOrNil
	^ self items isEmptyOrNil
%

category: 'testing'
method: GtOpenAIGroup
isNotEmpty

	^ self items isNotEmpty
%

category: 'accessing'
method: GtOpenAIGroup
items
	^ items ifNil: [
		items := OrderedCollection new ]
%

category: 'accessing'
method: GtOpenAIGroup
last
	^ self items last
%

category: 'accessing'
method: GtOpenAIGroup
last: aCount
	^ self species 
		withAll: (self items last: aCount)
%

category: 'accessing'
method: GtOpenAIGroup
overlappingPairsDo: aBlock
	^ self items overlappingPairsDo: aBlock
%

category: 'printing'
method: GtOpenAIGroup
printOn: aStream
	super printOn: aStream.
	
	aStream 
		<< ' [';
		print: self size;
		<< ' ';
		<< (self size = 1 
			ifTrue: [ 'item' ]
			ifFalse: [ 'items' ]);
		<< ']'
%

category: 'enumerating'
method: GtOpenAIGroup
reject: aBlock
	^ self species 
		withAll: (self items reject: aBlock)
%

category: 'accessing'
method: GtOpenAIGroup
remove: anItem
	self items remove: anItem
%

category: 'accessing'
method: GtOpenAIGroup
removeAll
	self items removeAll
%

category: 'enumerating'
method: GtOpenAIGroup
reversed
	^ self species 
		withAll: (self items reversed)
%

category: 'enumerating'
method: GtOpenAIGroup
select: aBlock
	^ self species 
		withAll: (self items select: aBlock)
%

category: 'accessing'
method: GtOpenAIGroup
size
	^ self items size
%

category: 'sorting'
method: GtOpenAIGroup
sorted: aPredicate
	^ self species withAll: (self items sorted: aPredicate)
%

category: 'accessing'
method: GtOpenAIGroup
withIndexCollect: aBlock
	^ self items withIndexCollect: aBlock
%

category: 'accessing'
method: GtOpenAIGroup
withIndexDo: aBlock
	^ self items withIndexDo: aBlock
%

! Class implementation for 'GtOpenAIAnnotationsGroup'

!		Instance methods for 'GtOpenAIAnnotationsGroup'

category: 'accessing'
method: GtOpenAIAnnotationsGroup
gtAnnotationsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Annotations';
		priority: 2;
		items: [ self items ];
		column: 'Text' text: #text;
		column: 'Type' text: #type;
		column: 'File'
			text: [ :anAnnotation | anAnnotation file ifNil: [ '' ] ifNotNil: [ :aFile | aFile filename ] ]
%

! Class implementation for 'GtOpenAIAssistantChatGroup'

!		Instance methods for 'GtOpenAIAssistantChatGroup'

category: 'accessing'
method: GtOpenAIAssistantChatGroup
gtChatsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Chats';
		priority: 1;
		items: [ self items ];
		column: 'Assistant' text: [ :aChat | aChat assistant id ];
		column: 'Messages' text: [ :aChat | aChat messages size ];
		column: 'Last updated' text: [ :aChat | aChat lastUpdate ifNil: [ '' ] ]
%

! Class implementation for 'GtOpenAIAssistantsGroup'

!		Class methods for 'GtOpenAIAssistantsGroup'

category: 'as yet unclassified'
classmethod: GtOpenAIAssistantsGroup
itemClass
	^ GtOpenAIAssistant
%

! Class implementation for 'GtOpenAIEmbeddingsGroup'

!		Class methods for 'GtOpenAIEmbeddingsGroup'

category: 'accessing'
classmethod: GtOpenAIEmbeddingsGroup
from: aList
	^ self
		withAll: ((aList at: 'data')
				collect: [ :aModel | GtOpenAIEmbedding from: (aModel at: 'embedding') ])
%

! Class implementation for 'GtOpenAIFilesGroup'

!		Class methods for 'GtOpenAIFilesGroup'

category: 'accessing'
classmethod: GtOpenAIFilesGroup
itemClass
	^ GtOpenAIFile
%

!		Instance methods for 'GtOpenAIFilesGroup'

category: 'accessing'
method: GtOpenAIFilesGroup
gtFilesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [self items];
		column: 'ID' text: #id;
		column: 'Filename' text: #filename;
		column: 'Size' text: #bytes weight: 0.5;
		column: 'Created at' text: #createdAt weight: 0.5;
		column: 'Purpose' text: #purpose weight: 0.5;
		column: 'Status' text: #status weight: 0.5
%

! Class implementation for 'GtOpenAIFineTuningCheckpointsGroup'

!		Class methods for 'GtOpenAIFineTuningCheckpointsGroup'

category: 'accessing'
classmethod: GtOpenAIFineTuningCheckpointsGroup
itemClass
	^ GtOpenAIFineTuningCheckpoint
%

!		Instance methods for 'GtOpenAIFineTuningCheckpointsGroup'

category: 'accessing'
method: GtOpenAIFineTuningCheckpointsGroup
gtCheckpointsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Checkpoints';
		priority: 1;
		items: [ self items ];
		column: 'Step number'
			text: #stepNumber
			weight: 0.5;
		column: 'Metrics'
			text: [ :aCheckpoint | 
				', '
					join: (aCheckpoint metrics associations
							collect: [ :aPair | aPair key , ': ' , aPair value asString ]) ]
			weight: 2;
		column: 'Time'
			text: #createdAt
			weight: 0.5
%

! Class implementation for 'GtOpenAIFineTuningEventsGroup'

!		Class methods for 'GtOpenAIFineTuningEventsGroup'

category: 'accessing'
classmethod: GtOpenAIFineTuningEventsGroup
itemClass
	^ GtOpenAIFineTuningEvent
%

!		Instance methods for 'GtOpenAIFineTuningEventsGroup'

category: 'accessing'
method: GtOpenAIFineTuningEventsGroup
gtEventsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Events';
		priority: 1;
		items: [ self items ];
		column: 'Level' text: #level weight: 0.5;
		column: 'Message' text: #message weight: 2;
		column: 'Time' text: #createdAt weight: 0.5
%

! Class implementation for 'GtOpenAIMessagesGroup'

!		Class methods for 'GtOpenAIMessagesGroup'

category: 'accessing'
classmethod: GtOpenAIMessagesGroup
itemClass
	^ GtOpenAIMessage
%

!		Instance methods for 'GtOpenAIMessagesGroup'

category: 'accessing'
method: GtOpenAIMessagesGroup
gtMessagesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Messages';
		priority: 1;
		items: [ self items ];
		column: 'Role' text: #role width: 60;
		column: 'Message' text: #content
%

! Class implementation for 'GtOpenAIModelsGroup'

!		Class methods for 'GtOpenAIModelsGroup'

category: 'accessing'
classmethod: GtOpenAIModelsGroup
itemClass
	^ GtOpenAIModel
%

!		Instance methods for 'GtOpenAIModelsGroup'

category: 'accessing'
method: GtOpenAIModelsGroup
gtViewModelsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Models';
		priority: 1;
		items: [ self items sorted: [:a :b | a created > b created ] ];
		column: 'ID' text: #id;
		column: 'Owned by' text: #ownedBy;
		column: 'Created on' text: #created
%

! Class implementation for 'GtOpenAIStepsGroup'

!		Instance methods for 'GtOpenAIStepsGroup'

category: 'accessing'
method: GtOpenAIStepsGroup
gtStepsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Steps';
		priority: 1;
		items: [self items ];
		column: 'Name' text: #name weight: 0.5;
		column: 'Description' text: #description;
		column: 'Rules' text: #rules
%

! Class implementation for 'GtOpenAIVectorStoresGroup'

!		Class methods for 'GtOpenAIVectorStoresGroup'

category: 'as yet unclassified'
classmethod: GtOpenAIVectorStoresGroup
itemClass
	^ GtOpenAIVectorStore
%

! Class implementation for 'GtOpenAIRawToolMessage'

!		Instance methods for 'GtOpenAIRawToolMessage'

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
action
	^ 'Tool call(' , self toolCall humanReadable , ')'
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
actionModel
	^ self toolCall
%

category: 'accessing'
method: GtOpenAIRawToolMessage
chat
	^ chat
%

category: 'accessing'
method: GtOpenAIRawToolMessage
chat: anObject
	chat := anObject
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
content
	^ rawData
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
contentText
	^ STONJSON toString: rawData
%

category: 'accessing'
method: GtOpenAIRawToolMessage
createdAt
	^ createdAt
%

category: 'accessing'
method: GtOpenAIRawToolMessage
createdAt: anObject
	createdAt := anObject
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
gtViewRawDataFor: aView
	<gtView>
	<gtLlmMessageView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
id
	^ rawData at: 'id' ifAbsent: ''
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
initialize
	super initialize.

	createdAt := DateAndTime now
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
isAssistantRole
	^ false
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
isRawMessage
	^ true
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
isToolRole
	^ true
%

category: 'accessing'
method: GtOpenAIRawToolMessage
rawData
	^ rawData
%

category: 'accessing'
method: GtOpenAIRawToolMessage
rawData: anObject
	rawData := anObject
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
reasoning
	^ reasoning
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
reasoning: anObject
	reasoning := anObject
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
role
	^ 'raw'
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
senderText
	^ 'Assistant'
%

category: 'as yet unclassified'
method: GtOpenAIRawToolMessage
serialize
	^ rawData
%

category: 'accessing'
method: GtOpenAIRawToolMessage
toolCall
	^ toolCall
%

category: 'accessing'
method: GtOpenAIRawToolMessage
toolCall: anObject
	toolCall := anObject
%

! Class implementation for 'GtOpenAIResourceFile'

!		Instance methods for 'GtOpenAIResourceFile'

category: 'as yet unclassified'
method: GtOpenAIResourceFile
contents
	^ file contents
%

category: 'accessing'
method: GtOpenAIResourceFile
description
	^ description
%

category: 'accessing'
method: GtOpenAIResourceFile
description: anObject
	description := anObject
%

category: 'accessing'
method: GtOpenAIResourceFile
file
	^ file
%

category: 'accessing'
method: GtOpenAIResourceFile
file: anObject
	file := anObject
%

category: 'as yet unclassified'
method: GtOpenAIResourceFile
filename
	^ file filename
%

category: 'as yet unclassified'
method: GtOpenAIResourceFile
gtContentsFor: aView
	<gtView>
	^ aView forward
		title: 'Contents';
		priority: 5;
		object: [ file ];
		view: #gtContentsFor:
%

category: 'accessing'
method: GtOpenAIResourceFile
gtDescriptionFor: aView
	<gtView>
	^ aView textEditor
		title: 'Description';
		priority: 1;
		text: [ self toFileDescription ]
%

category: 'accessing'
method: GtOpenAIResourceFile
remoteId
	^ remoteId
%

category: 'accessing'
method: GtOpenAIResourceFile
remoteId: anObject
	remoteId := anObject
%

category: 'accessing'
method: GtOpenAIResourceFile
toFileDescription
	^ (self remoteId ifNil: [ '<unknown ID>' ])
		, ':
- Name: ' , self file basename
		, '
- Description: ' , self description
%

! Class implementation for 'GtPretrainedEncoder'

!		Instance methods for 'GtPretrainedEncoder'

category: 'accessing'
method: GtPretrainedEncoder
decode: aListOfTokens
	| aResult |
	aResult := OrderedCollection new.
	aListOfTokens
		do: [ :aToken | aResult addAll: (self reversedMerges at: aToken ifAbsent: [ {aToken} ]) ].
	^ ZnUTF8Encoder default decodeBytes: aResult
%

category: 'accessing'
method: GtPretrainedEncoder
encode: aString
	| encoder tokens continue |
	encoder := GtBPEEncoder new.
	tokens := encoder tokenize: aString.
	continue := true.
	[ continue ]
		whileTrue: [ | stats pair |
			stats := encoder getStatsFor: tokens.
			pair := stats keys
					detectMin: [ :aPair | merges at: aPair ifAbsent: Float infinity ].
			(merges includesKey: pair)
				ifTrue: [ tokens := encoder
							mergePair: pair
							into: (merges at: pair)
							inTokens: tokens.
					continue := tokens size >= 2 ]
				ifFalse: [ continue := false ] ].
	^ tokens
%

category: 'accessing'
method: GtPretrainedEncoder
gtMergesFor: aView
	<gtView>
	^ aView columnedList
		title: 'Merges';
		priority: 4;
		items: [ self merges associations ];
		column: 'Input pair' text: [ :aPair | ', ' join: aPair key ];
		column: 'Output token' text: #value
%

category: 'accessing'
method: GtPretrainedEncoder
merges
	^ merges
%

category: 'accessing'
method: GtPretrainedEncoder
merges: anObject
	merges := anObject.

	self reversedMergesFromMerges
%

category: 'accessing'
method: GtPretrainedEncoder
reversedMergeFor: aKeyList in: simplyReversedMerges
	| aResult nextKeys |
	aResult := OrderedCollection new.
	nextKeys := aKeyList asOrderedCollection.
	[ nextKeys isNotEmpty ]
		whileTrue: [ | nextKey |
			nextKey := nextKeys removeFirst.
			(simplyReversedMerges includesKey: nextKey)
				ifTrue: [ nextKeys addAllFirst: (simplyReversedMerges at: nextKey) ]
				ifFalse: [ aResult add: nextKey ] ].
	^ aResult
%

category: 'accessing'
method: GtPretrainedEncoder
reversedMerges
	^ reversedMerges
%

category: 'accessing'
method: GtPretrainedEncoder
reversedMerges: anObject
	reversedMerges := anObject
%

category: 'accessing'
method: GtPretrainedEncoder
reversedMergesFromMerges
	| simplyReversedMerges |
	simplyReversedMerges := (self merges associations
			collect: [ :anAssociation | Association key: anAssociation value value: anAssociation key ])
			asDictionary.
	self
		reversedMerges: (simplyReversedMerges
				collect: [ :aValue | self reversedMergeFor: aValue in: simplyReversedMerges ])
%

! Class implementation for 'GtLlmRequestHistory'

!		Instance methods for 'GtLlmRequestHistory'

category: 'as yet unclassified'
method: GtLlmRequestHistory
add: aPair
	super
		add: (GtLlmRequestResponse new
				request: aPair key;
				response: aPair value)
%

category: 'as yet unclassified'
method: GtLlmRequestHistory
gtCallsFor: aView
	<gtView>
	^ aView columnedList
		title: 'Calls';
		priority: 5;
		items: [ self ];
		column: 'URL' text: [ :aRequestResponse | aRequestResponse request url ];
		column: 'Method' text: [ :aRequestResponse | aRequestResponse request method ] width: 100
%

! Class extensions for 'ExecBlock'

!		Instance methods for 'ExecBlock'

category: '*Gt4Llm-Gemstone'
method: ExecBlock
doWhileTrue: aBlock
	self value.
	^ aBlock whileTrue: self
%

! Class extensions for 'GtLlmActionChat'

!		Instance methods for 'GtLlmActionChat'

category: '*Gt4Ollama'
method: GtLlmActionChat
messageClassForOllama
	^ GtLlmActionMessage
%

category: '*Gt4OpenAI'
method: GtLlmActionChat
messageClassForOpenAI
	^ GtOpenAIActionMessage
%

! Class extensions for 'GtLlmAssistantAction'

!		Instance methods for 'GtLlmAssistantAction'

category: '*Gt4Llm-Gemstone'
method: GtLlmAssistantAction
initializeMethod
	^ nil
%

! Class extensions for 'GtLlmAssistantActionExample'

!		Instance methods for 'GtLlmAssistantActionExample'

category: '*Gt4Llm-Gemstone'
method: GtLlmAssistantActionExample
assert: aBoolean description: aString
  | str | 
  aBoolean == true  ifFalse: [
    str := aString .
    str _isExecBlock ifTrue:[ str := aString value ].
    self logFailure: str.
    ^ GtGemStoneAssertionFailure signal: str
  ]
%

! Class extensions for 'GtLlmAssistantFormatDescription'

!		Instance methods for 'GtLlmAssistantFormatDescription'

category: '*Gt4Llm-Gemstone'
method: GtLlmAssistantFormatDescription
initializeMethod
	^ nil
%

! Class extensions for 'GtLlmChat'

!		Instance methods for 'GtLlmChat'

category: '*Gt4Ollama'
method: GtLlmChat
messageClassForOllama
	^ GtLlmChatMessage
%

category: '*Gt4OpenAI'
method: GtLlmChat
messageClassForOpenAI
	^ GtOpenAIMessage
%

! Class extensions for 'GtLlmChatExamples'

!		Instance methods for 'GtLlmChatExamples'

category: '*Gt4Llm-Gemstone'
method: GtLlmChatExamples
assert: aBoolean
	self
		assert: aBoolean
		description: 'assert is not true'
%

category: '*Gt4Llm-Gemstone'
method: GtLlmChatExamples
assert: aBoolean description: aString
  | str | 
  aBoolean == true  ifFalse: [
    str := aString .
    str _isExecBlock ifTrue:[ str := aString value ].
    self logFailure: str.
    ^ GtGemStoneAssertionFailure signal: str
  ]
%

category: '*Gt4Llm-Gemstone'
method: GtLlmChatExamples
assert: actual equals: expected
	self
		assert: actual = expected
		description: actual printString , ' is not equal to ' , expected printString
%

! Class extensions for 'GtLlmChatMessage'

!		Class methods for 'GtLlmChatMessage'

category: '*Gt4Llm-Gemstone'
classmethod: GtLlmChatMessage
isAbstract
	^ self name = #GtLlmChatMessage
%

!		Instance methods for 'GtLlmChatMessage'

category: '*Gt4Llm-Gemstone'
method: GtLlmChatMessage
gtContentFor: aView
	<gtView>
	<gtLlmMessageView>
	^ aView textEditor
		title: 'Content';
		priority: 5;
		text: [ self contentText ]
%

category: '*Gt4Llm-Gemstone'
method: GtLlmChatMessage
gtJsonFor: aView
	<gtView>
	<gtLlmMessageView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtItemsFor: aView)
		title: 'JSON data';
		priority: 4.5
%

! Class extensions for 'GtLlmConnectionRegistry'

!		Instance methods for 'GtLlmConnectionRegistry'

category: '*Gt4Llm-Gemstone'
method: GtLlmConnectionRegistry
knownConnectors
	^ {GtLlmConnection new
			provider: GtOllamaProvider;
			label: 'Llama 3.1';
			model: 'llama3.1'}
%

! Class extensions for 'GtOllamaClient'

!		Class methods for 'GtOllamaClient'

category: '*Gt4Llm-Gemstone'
classmethod: GtOllamaClient
new
	^ self basicNew initialize
%

!		Instance methods for 'GtOllamaClient'

category: '*Gt4Ollama-Gemstone'
method: GtOllamaClient
initializeClient
	^ GtGemstoneHttpClient new
%

category: '*Gt4Ollama-Gemstone'
method: GtOllamaClient
postStreaming: aString withEntity: anEntity
	| aClient |
	aClient := self initializeClient beOneShot.
	aClient url: self baseUrl / aString.

	aClient contents: anEntity.

	^ self checkForErrors: aClient postStreaming
%

! Class extensions for 'GtOllamaProvider'

!		Instance methods for 'GtOllamaProvider'

category: '*Gt4Ollama-Gemstone'
method: GtOllamaProvider
asyncWait
	^ self triggerAssistant
%

category: '*Gt4Ollama-Gemstone'
method: GtOllamaProvider
uuidClass
	^ GsUuidV4
%

! Class extensions for 'GtOpenAIAssistantProvider'

!		Instance methods for 'GtOpenAIAssistantProvider'

category: '*Gt4OpenAI-Gemstone'
method: GtOpenAIAssistantProvider
executeWait
	[ self getRun isDone ] whileFalse: [ 5 seconds wait ].

	self updateMessages.
	chat signalRunIsDone
%

category: '*Gt4OpenAI-Gemstone'
method: GtOpenAIAssistantProvider
registerForFinalization
%

! Class extensions for 'GtOpenAIClient'

!		Instance methods for 'GtOpenAIClient'

category: '*Gt4OpenAI-Gemstone'
method: GtOpenAIClient
initializeClient
	^ GtGemstoneHttpClient new
		authorization: 'Bearer ' , self apiKey;
		headerAt: 'OpenAI-Beta' put: 'assistants=v2'
%

! Class extensions for 'GtOpenAIGenerateResponseAPIClient'

!		Instance methods for 'GtOpenAIGenerateResponseAPIClient'

category: '*Gt4OpenAI-Gemstone'
method: GtOpenAIGenerateResponseAPIClient
request
	^ self client post: '/responses' withEntity: (self buildEntity at: 'stream' put: false; yourself)
%

category: '*Gt4OpenAI-Gemstone'
method: GtOpenAIGenerateResponseAPIClient
serializationClass
	^ GtOpenAIResponse
%

! Class extensions for 'GtOpenAIResponseProvider'

!		Instance methods for 'GtOpenAIResponseProvider'

category: '*Gt4OpenAI-Gemstone'
method: GtOpenAIResponseProvider
executeWait
	| result aMessage |
	result := client
		generateResponseWithModel: self model
		messages: self chat messages
		instructions: instructions
		tools: tools
		andFormat: format.

	result hasToolCalls
		ifTrue: [ ^ self performToolCallsIn: result ].
	aMessage := self assistantMessageClass new merge: result output first.


	self chat addMessage: aMessage.

	self chat signalRunIsDone.
	assistantWorking := false
%

! Class extensions for 'String'

!		Instance methods for 'String'

category: '*Gt4Llm'
method: String
asInstructionPiece
	^ GtLlmInstructionString new string: self
%

category: '*Gt4Llm'
method: String
formatCount
	"Count the number of arguments #format: would expect."

	| stream counter |
	counter := Set new.
	stream := self readStream.
	[ stream atEnd ]
		whileFalse: [ | currentChar |
			(currentChar := stream next) == ${
				ifTrue: [ | expression |
					expression := stream upTo: $}.
					counter add: expression ]
				ifFalse: [ currentChar == $\
						ifTrue: [ stream atEnd ifFalse: [ stream next ] ] ] ].

	^ counter size
%

! Class Initialization

run
GtLlmFeatures initialize.
GtOllamaProvider initialize.
GtOpenAIClient initialize.
true
%
