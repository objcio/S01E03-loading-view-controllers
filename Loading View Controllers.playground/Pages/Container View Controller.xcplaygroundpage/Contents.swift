import UIKit

// To run this playground start a SimpleHTTPServer on the commandline like this:
//
// python -m SimpleHTTPServer 8000
//
// It will serve up the current directory, so make sure to be in the directory containing episode.json

let url = NSURL(string: "http://localhost:8000/episode.json")!
let episodeResource = Resource<Episode>(url: url, parseJSON: { anyObject in
    (anyObject as? JSONDictionary).flatMap(Episode.init)
})


final class LoadingViewController: UIViewController {
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)

    init<A>(load: ((Result<A>) -> ()) -> (), build: (A) -> UIViewController) {
        super.init(nibName: nil, bundle: nil)
        spinner.startAnimating()
        load() { [weak self] result in
            self?.spinner.stopAnimating()
            guard let value = result.value else { return } // TODO loading error
            let viewController = build(value)
            self?.add(content: viewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.center(inView: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(content content: UIViewController) {
        addChildViewController(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        content.view.constrainEdges(toMarginOf: view)
        content.didMoveToParentViewController(self)
    }
}


final class EpisodeDetailViewController: UIViewController {
    let titleLabel = UILabel()
    
    convenience init(episode: Episode) {
        self.init()
        titleLabel.text = episode.title
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.constrainEdges(toMarginOf: view)
    }
}


let sharedWebservice = Webservice()

let episodesVC = LoadingViewController(load: { callback in
    sharedWebservice.load(episodeResource, completion: callback)
}, build: EpisodeDetailViewController.init)

episodesVC.view.frame = CGRect(x: 0, y: 0, width: 250, height: 300)


import XCPlayground
XCPlaygroundPage.currentPage.liveView = episodesVC
