<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    /* 轮播图容器 */
    .carousel-container {
        position: relative;
        width: 100%;
        height: 460px; /* 稍微调低一点高度，适配容器宽度 */
        overflow: hidden;
        margin-bottom: 40px;
        border-radius: 24px; /* 【核心修改】增加圆角，使其成为卡片风格 */
        box-shadow: 0 10px 30px rgba(0,0,0,0.08); /* 增加一点阴影立体感 */
    }

    /* 每一张幻灯片 */
    .carousel-slide {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        transition: opacity 0.6s ease-in-out; /* 稍微加快切换速度 */
        display: flex;
        align-items: center;
        justify-content: center;
        background-size: cover;
        background-position: center;
    }

    .carousel-slide.active {
        opacity: 1;
        z-index: 1;
    }

    /* 文字内容 */
    .carousel-caption {
        text-align: center;
        color: white;
        z-index: 2;
        text-shadow: 0 4px 12px rgba(0,0,0,0.2);
        max-width: 800px;
        padding: 20px;
        transform: translateY(10px);
        transition: transform 0.6s ease-out;
    }

    /* 激活时文字上浮动效 */
    .carousel-slide.active .carousel-caption {
        transform: translateY(0);
    }

    .carousel-caption h2 { font-size: 42px; margin-bottom: 12px; font-weight: 700; letter-spacing: -1px; }
    .carousel-caption p { font-size: 18px; margin-bottom: 30px; opacity: 0.95; font-weight: 500; }

    /* 左右切换按钮 */
    .carousel-btn {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        background: rgba(255,255,255,0.15);
        backdrop-filter: blur(5px);
        border: none;
        color: white;
        font-size: 20px;
        width: 44px;
        height: 44px;
        border-radius: 50%;
        cursor: pointer;
        z-index: 10;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .carousel-btn:hover { background: rgba(255,255,255,0.3); transform: translateY(-50%) scale(1.1); }
    .carousel-prev { left: 20px; }
    .carousel-next { right: 20px; }

    /* 底部指示点 */
    .carousel-dots {
        position: absolute;
        bottom: 20px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 10;
        display: flex;
        gap: 8px;
    }
    .dot {
        width: 8px;
        height: 8px;
        background: rgba(255,255,255,0.4);
        border-radius: 50%;
        cursor: pointer;
        transition: all 0.3s;
    }
    .dot.active { width: 24px; border-radius: 4px; background: #fff; }

    /* 按钮样式优化 */
    .banner-btn {
        background: #fff;
        color: #1d1d1f;
        padding: 12px 32px;
        border-radius: 30px;
        text-decoration: none;
        font-weight: 600;
        font-size: 14px;
        display: inline-block;
        transition: transform 0.2s;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }
    .banner-btn:hover { transform: scale(1.05); }
</style>

<div class="carousel-container" id="mainCarousel">
    <div class="carousel-slide active" style="background: linear-gradient(120deg, #2b5876 0%, #4e4376 100%);">
        <div class="carousel-caption">
            <h2>iPhone 15 Pro</h2>
            <p>钛金属设计，A17 Pro 芯片，性能怪兽。</p>
            <a href="searchMobile.jsp?searchMess=iPhone" class="banner-btn">立即探索</a>
        </div>
    </div>

    <div class="carousel-slide" style="background: linear-gradient(120deg, #ff9a9e 0%, #fecfef 99%, #fecfef 100%);">
        <div class="carousel-caption">
            <h2 style="color: #333;">华为 Mate 60 Pro</h2>
            <p style="color: #444;">同心聚力，连接未来。遥遥领先。</p>
            <a href="searchMobile.jsp?searchMess=Huawei" class="banner-btn" style="background: #1d1d1f; color: #fff;">查看详情</a>
        </div>
    </div>

    <div class="carousel-slide" style="background: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);">
        <div class="carousel-caption">
            <h2 style="color: #0d324d;">小米 14 Ultra</h2>
            <p style="color: #0d324d;">徕卡光学，移动影像新层次。</p>
            <a href="searchMobile.jsp?searchMess=Xiaomi" class="banner-btn" style="background: #0071e3; color: #fff;">立即抢购</a>
        </div>
    </div>

    <button class="carousel-btn carousel-prev" onclick="moveSlide(-1)">&#10094;</button>
    <button class="carousel-btn carousel-next" onclick="moveSlide(1)">&#10095;</button>

    <div class="carousel-dots" id="dotsContainer">
        <div class="dot active" onclick="currentSlide=0; showSlide(0)"></div>
        <div class="dot" onclick="currentSlide=1; showSlide(1)"></div>
        <div class="dot" onclick="currentSlide=2; showSlide(2)"></div>
    </div>
</div>

<script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-slide');
    const dots = document.querySelectorAll('.dot');

    function showSlide(n) {
        // 循环逻辑
        slides.forEach(slide => slide.classList.remove('active'));
        dots.forEach(dot => dot.classList.remove('active'));

        currentSlide = (n + slides.length) % slides.length;

        slides[currentSlide].classList.add('active');
        dots[currentSlide].classList.add('active');
    }

    function moveSlide(n) {
        showSlide(currentSlide + n);
    }

    // 自动轮播 (5秒)
    let autoSlide = setInterval(() => {
        moveSlide(1);
    }, 5000);

    // 鼠标悬停时暂停轮播
    const container = document.getElementById('mainCarousel');
    container.addEventListener('mouseenter', () => clearInterval(autoSlide));
    container.addEventListener('mouseleave', () => {
        autoSlide = setInterval(() => moveSlide(1), 5000);
    });
</script>
