
//  Created by Maxim Soldatov on 11/29/20.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
import EssentialApp

class FeedImageCommentsUIIntegrationTests: XCTestCase {
	
	func test_loadCommentsAction_requestCommentsFromLoader() {
		let (sut, loader) = makeSUT()
		XCTAssertEqual(loader.loadCommentsCallCount, 0, "Expected no loading requests before view is loaded")
		
		sut.loadViewIfNeeded()
		XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected a loading request once view is loaded")
		
		sut.simulateUserInitiatedCommentsReload()
		XCTAssertEqual(loader.loadCommentsCallCount, 2, "Expected a loading request once view is loaded")
		
		sut.simulateUserInitiatedCommentsReload()
		XCTAssertEqual(loader.loadCommentsCallCount, 3, "Expected yet another loading request once user initiates another reload")
	}
	
	//MARK: -Helpers
	
	private func makeSUT(url: URL = anyURL(),file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageCommentsViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedImageCommentsUIComposer.imageCommentsComposeWith(commentsLoader: loader, url: url)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, loader)
	}
	
	private class LoaderSpy: FeedImageCommentsLoader {
		var loadCommentsCallCount = 0
		
		private struct Task: FeedImageCommentsLoaderTask {
			func cancel() {}
		}
		
		func load(from _: URL, completion _: @escaping (FeedImageCommentsLoader.Result) -> Void) -> FeedImageCommentsLoaderTask {
			loadCommentsCallCount += 1
			return Task()
		}
	}
	
}

private extension FeedImageCommentsViewController {
	func simulateUserInitiatedCommentsReload() {
		refreshControl?.simulatePullToRefresh()
	}
}