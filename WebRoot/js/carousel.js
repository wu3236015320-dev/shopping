/**
 * 推荐商品轮盘交互逻辑
 * 支持：左右切换、触摸滑动、键盘控制、自动轮播
 */

(function() {
    'use strict';

    // 轮盘配置
    const CONFIG = {
        autoPlayInterval: 5000,  // 自动轮播间隔（毫秒）
        transitionDuration: 500  // 切换动画持续时间（毫秒）
    };

    // 轮盘状态
    let currentIndex = 0;
    let slides = [];
    let dots = [];
    let autoPlayTimer = null;
    let isAutoPlaying = true;
    let touchStartX = 0;
    let touchEndX = 0;

    /**
     * 初始化轮盘
     */
    function initCarousel() {
        const container = document.getElementById('productCarousel');
        if (!container) return;

        slides = container.querySelectorAll('.carousel-slide');
        dots = document.querySelectorAll('#carouselDots .carousel-dot');

        if (slides.length === 0) return;

        // 绑定箭头按钮事件
        const prevBtn = container.querySelector('.carousel-arrow-prev');
        const nextBtn = container.querySelector('.carousel-arrow-next');

        if (prevBtn) {
            prevBtn.addEventListener('click', function(e) {
                e.preventDefault();
                stopAutoPlay();
                goToPrev();
                startAutoPlay();
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', function(e) {
                e.preventDefault();
                stopAutoPlay();
                goToNext();
                startAutoPlay();
            });
        }

        // 绑定圆点点击事件
        dots.forEach(function(dot, index) {
            dot.addEventListener('click', function() {
                stopAutoPlay();
                goToSlide(index);
                startAutoPlay();
            });
        });

        // 触摸滑动支持
        container.addEventListener('touchstart', handleTouchStart, { passive: true });
        container.addEventListener('touchend', handleTouchEnd, { passive: true });

        // 鼠标悬停暂停自动播放
        container.addEventListener('mouseenter', stopAutoPlay);
        container.addEventListener('mouseleave', startAutoPlay);

        // 键盘左右键支持
        document.addEventListener('keydown', handleKeyboard);

        // 初始化显示
        updateCarousel();

        // 启动自动轮播
        startAutoPlay();
    }

    /**
     * 切换到上一个商品
     */
    function goToPrev() {
        let newIndex = currentIndex - 1;
        if (newIndex < 0) {
            newIndex = slides.length - 1;
        }
        goToSlide(newIndex);
    }

    /**
     * 切换到下一个商品
     */
    function goToNext() {
        let newIndex = currentIndex + 1;
        if (newIndex >= slides.length) {
            newIndex = 0;
        }
        goToSlide(newIndex);
    }

    /**
     * 跳转到指定索引的商品
     */
    function goToSlide(index) {
        if (index < 0 || index >= slides.length) return;
        if (index === currentIndex) return;

        currentIndex = index;
        updateCarousel();
    }

    /**
     * 更新轮盘显示状态
     * 支持有限列表循环展示
     */
    function updateCarousel() {
        const totalSlides = slides.length;

        slides.forEach(function(slide, index) {
            // 移除所有状态类
            slide.classList.remove('prev', 'active', 'next', 'hidden');

            // 计算相对位置（支持循环）
            let diff = index - currentIndex;

            // 处理循环边界
            if (diff > totalSlides / 2) {
                diff -= totalSlides;
            } else if (diff < -totalSlides / 2) {
                diff += totalSlides;
            }

            if (index === currentIndex) {
                // 当前激活的幻灯片 - 居中放大
                slide.classList.add('active');
            } else if (diff === -1 || (currentIndex === 0 && index === totalSlides - 1 && totalSlides > 1)) {
                // 前一个幻灯片 - 左侧
                slide.classList.add('prev');
            } else if (diff === 1 || (currentIndex === totalSlides - 1 && index === 0 && totalSlides > 1)) {
                // 后一个幻灯片 - 右侧
                slide.classList.add('next');
            } else {
                // 其他幻灯片隐藏
                slide.classList.add('hidden');
            }
        });

        // 更新圆点状态
        dots.forEach(function(dot, index) {
            if (index === currentIndex) {
                dot.classList.add('active');
            } else {
                dot.classList.remove('active');
            }
        });
    }

    /**
     * 处理触摸开始事件
     */
    function handleTouchStart(e) {
        touchStartX = e.changedTouches[0].screenX;
    }

    /**
     * 处理触摸结束事件
     */
    function handleTouchEnd(e) {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    }

    /**
     * 处理滑动手势
     */
    function handleSwipe() {
        const swipeThreshold = 50;  // 滑动阈值
        const diff = touchStartX - touchEndX;

        if (Math.abs(diff) > swipeThreshold) {
            stopAutoPlay();
            if (diff > 0) {
                // 向左滑动，显示下一个
                goToNext();
            } else {
                // 向右滑动，显示上一个
                goToPrev();
            }
            startAutoPlay();
        }
    }

    /**
     * 处理键盘事件
     */
    function handleKeyboard(e) {
        // 只有当轮盘在视口内时才响应键盘事件
        const container = document.getElementById('productCarousel');
        if (!container) return;

        const rect = container.getBoundingClientRect();
        const isInViewport = rect.top < window.innerHeight && rect.bottom > 0;

        if (!isInViewport) return;

        if (e.key === 'ArrowLeft') {
            e.preventDefault();
            stopAutoPlay();
            goToPrev();
            startAutoPlay();
        } else if (e.key === 'ArrowRight') {
            e.preventDefault();
            stopAutoPlay();
            goToNext();
            startAutoPlay();
        }
    }

    /**
     * 启动自动轮播
     */
    function startAutoPlay() {
        if (!isAutoPlaying || slides.length <= 1) return;

        stopAutoPlay();  // 先清除现有的定时器
        autoPlayTimer = setInterval(function() {
            goToNext();
        }, CONFIG.autoPlayInterval);
    }

    /**
     * 停止自动轮播
     */
    function stopAutoPlay() {
        if (autoPlayTimer) {
            clearInterval(autoPlayTimer);
            autoPlayTimer = null;
        }
    }

    /**
     * 页面可见性变化处理
     * 当页面不可见时暂停自动轮播，节省资源
     */
    function handleVisibilityChange() {
        if (document.hidden) {
            stopAutoPlay();
        } else {
            startAutoPlay();
        }
    }

    // 监听页面可见性变化
    document.addEventListener('visibilitychange', handleVisibilityChange);

    // DOM加载完成后初始化轮盘
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initCarousel);
    } else {
        initCarousel();
    }

})();
