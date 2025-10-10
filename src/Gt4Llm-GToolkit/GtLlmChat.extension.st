Extension { #name : #GtLlmChat }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> asElement [
	^ GtLlmChatElement new chatViewModel: self asViewModel
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> asViewModel [
	^ GtLlmChatViewModel new assistantChat: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> copyLepiterSerialisationToClipboard [
	| snippet serialization |

	snippet := GtLlmLeSnippetVisitor new visitNode: self.
	serialization := LeJsonV4 uniqueInstance serialize: snippet.
	Clipboard default clipboardText: serialization.
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> gtCopySnippetSerialisationFor: anAction [
	"Copy the serialisation of the receiver's Lepiter snippet to the clipboard.
	This can then be pasted as a snippet from a lepiter page."
	<gtAction>

	^ anAction button
		icon: BrGlamorousVectorIcons copyToClipboard;
		tooltip: 'Copy the snippet definition to the clipboard';
		action: [ :button | self copyLepiterSerialisationToClipboard ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> gtMessagesWidgetFor: aView [
	"cannot be a forward because the update wouldn’t work"

	<gtView>
	self provider ifNil: [ ^ aView empty ].

	^ aView explicit
		title: 'Chat';
		priority: 0;
		stencil: [ self asElement ];
		actionUpdateButton;
		actionButtonIcon: BrGlamorousVectorIcons bin
			tooltip: 'Delete history'
			action: [ self reset ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChat >> whenReadyFuture [
	^ GtLlmChatReadyFuture new chat: self
]
