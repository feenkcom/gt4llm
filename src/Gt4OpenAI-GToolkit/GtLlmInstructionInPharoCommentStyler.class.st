Class {
	#name : #GtLlmInstructionInPharoCommentStyler,
	#superclass : #GtGenericPharoStyler,
	#instVars : [
		'llmChat'
	],
	#category : #'Gt4OpenAI-GToolkit'
}

{ #category : #'*Gt4OpenAI-GToolkit' }
GtLlmInstructionInPharoCommentStyler >> llmChat: anObject [ 
	llmChat := anObject
]

{ #category : #'as yet unclassified' }
GtLlmInstructionInPharoCommentStyler >> visitSmaCCParseNode: aSmaCCParseNode [
	super visitSmaCCParseNode: aSmaCCParseNode.
	aSmaCCParseNode comments
		ifNotNil: [ :theComments | 
			GtLlmStylerSignal emit.
			theComments
				do: [ :each | 
					((aSmaCCParseNode completeSource asString copyFrom: each first to: each second)
						beginsWith: '":')
						ifTrue: [ self
								attribute: (GtButtonAttribute new
										beAppend;
										stencil: [ | button |
											button := BrButton new.
											button
												aptitude: BrGlamorousButtonWithIconAptitude
														+ (BrGlamorousWithExplicitDropdownAptitude
																handle: [ BrButton new
																		icon: BrGlamorousIcons empty;
																		beTinySize;
																		aptitude: BrGlamorousButtonRectangularAptitude new + BrGlamorousButtonIconAptitude new ]
																content: [ GtLlmEmbeddedChatElement new chatViewModel: coderViewModel coderModel llmChat asViewModel ]);
												icon: BrGlamorousVectorIcons openAi;
												label: 'Propose change';
												beTinySize;
												margin: (BlInsets left: 2 right: 2);
												yourself ])
								from: each first
								to: each second ] ] ]
]
