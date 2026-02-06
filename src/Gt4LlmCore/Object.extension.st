Extension { #name : #Object }

{ #category : #'*Gt4LlmCore' }
Object >> addContentOneLineSummaryTo: aWriteStream [
	self gtDisplayOn: aWriteStream
]

{ #category : #'*Gt4LlmCore' }
Object >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

{ #category : #'*Gt4LlmCore' }
Object >> gtActionObjectChatFor: anAction [
	<gtAction>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].
	^ anAction button
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about this object';
		action: [ :button | 
			| chat |
			chat := GtLChat new
					markdownResponse;
					sendWith: [ :m | 
						m
							addPlainInputObject: self named: 'Object';
							markdown: 'Describe the object' ].
			button phlow spawnObject: chat ]
]
