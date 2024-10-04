//
//  ProjectPageViewController.swift
//  SKILIKET Project Team 7
//
//  Created by Ramir Alcocer on 03/10/24.
//
import UIKit

class ProjectPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        // Configura los datos de cada página
        let page1 = createPage(image: UIImage(named: "project1"), title: "Urban Air Quality Monitoring", description: "Description here")
        let page2 = createPage(image: UIImage(named: "project2"), title: "Project Title 2", description: "Description here")
        // Añade más páginas según sea necesario
        
        pages.append(contentsOf: [page1, page2])
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func createPage(image: UIImage?, title: String, description: String) -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageDataViewController") as! PageDataViewController
        vc.image = image
        vc.titleText = title
        vc.descriptionText = description
        return vc
    }
}

